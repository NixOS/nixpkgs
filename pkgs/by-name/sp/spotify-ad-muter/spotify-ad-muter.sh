#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Luna5akura
# SPDX-License-Identifier: MIT

RESUME_DELAY="${SPOTIFY_AD_MUTER_RESUME_DELAY:-2}"
case "$RESUME_DELAY" in
  ''|*[!0-9.]*)
    RESUME_DELAY=2
    ;;
esac

COMMAND_TIMEOUT="${SPOTIFY_AD_MUTER_COMMAND_TIMEOUT:-2}"
case "$COMMAND_TIMEOUT" in
  ''|*[!0-9.]*)
    COMMAND_TIMEOUT=2
    ;;
esac

STATE_DIR=""
STATE_FILE=""
PERSISTENT_STATE_DIR=""
MUTED_MARKER_FILE=""
LEGACY_RECOVERY_FILE=""
AD_REASON=""
AD_CANDIDATE_KEY=""
AD_CANDIDATE_COUNT=0

log() {
  printf 'spotify-ad-muter: %s\n' "$*"
}

ensure_session_env() {
  if [[ -z "${XDG_RUNTIME_DIR:-}" || ! -d "$XDG_RUNTIME_DIR" ]]; then
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
    export XDG_RUNTIME_DIR
  fi

  if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" && -S "$XDG_RUNTIME_DIR/bus" ]]; then
    DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
    export DBUS_SESSION_BUS_ADDRESS
  fi

  if [[ -z "${PULSE_SERVER:-}" && -S "$XDG_RUNTIME_DIR/pulse/native" ]]; then
    PULSE_SERVER="unix:$XDG_RUNTIME_DIR/pulse/native"
    export PULSE_SERVER
  fi

  STATE_DIR="$XDG_RUNTIME_DIR/spotify-ad-muter"
  STATE_FILE="$STATE_DIR/spotify-sink-inputs"

  if [[ -n "${XDG_STATE_HOME:-}" ]]; then
    PERSISTENT_STATE_DIR="$XDG_STATE_HOME/spotify-ad-muter"
  elif [[ -n "${HOME:-}" ]]; then
    PERSISTENT_STATE_DIR="$HOME/.local/state/spotify-ad-muter"
  else
    PERSISTENT_STATE_DIR="$STATE_DIR"
  fi

  MUTED_MARKER_FILE="$PERSISTENT_STATE_DIR/muted-by-us"
  LEGACY_RECOVERY_FILE="$PERSISTENT_STATE_DIR/legacy-mute-recovery-done"
}

metadata_value() {
  timeout --foreground "${COMMAND_TIMEOUT}s" playerctl -p spotify metadata "$1" 2>/dev/null || true
}

spotify_available() {
  timeout --foreground "${COMMAND_TIMEOUT}s" playerctl -p spotify status >/dev/null 2>&1
}

metadata_has_real_media() {
  local trackid_lc="$1"
  local url_lc="$2"

  [[ "$trackid_lc" == /com/spotify/track/* ||
     "$trackid_lc" == /com/spotify/episode/* ||
     "$trackid_lc" == /com/spotify/local/* ||
     "$url_lc" == spotify:track:* ||
     "$url_lc" == spotify:episode:* ||
     "$url_lc" == spotify:local:* ||
     "$url_lc" == *open.spotify.com/track/* ||
     "$url_lc" == *open.spotify.com/episode/* ]]
}

metadata_has_ad_marker() {
  local trackid_lc="$1"
  local url_lc="$2"

  [[ "$trackid_lc" == *":ad:"* ||
     "$trackid_lc" == *"/ad/"* ||
     "$url_lc" == spotify:ad:* ||
     "$url_lc" == *open.spotify.com/ad/* ]]
}

title_looks_like_ad() {
  local title_lc="$1"

  [[ "$title_lc" == "spotify" ||
     "$title_lc" == *advertisement* ||
     "$title_lc" == *"spotify ad"* ||
     "$title_lc" == *"ad-free"* ||
     "$title_lc" == *sponsored* ||
     "$title_lc" == *"listen to music"* ||
     "$title_lc" == *"out now"* ||
     "$title_lc" == *"無廣告"* ||
     "$title_lc" == *"无广告"* ||
     "$title_lc" == *"廣告"* ||
     "$title_lc" == *"广告"* ||
     "$title_lc" == *"立即收聽"* ||
     "$title_lc" == *"立即收听"* ||
     "$title_lc" == *"馬上點聽"* ||
     "$title_lc" == *"马上点听"* ||
     "$title_lc" == *"最新單曲"* ||
     "$title_lc" == *"最新单曲"* ||
     "$title_lc" == *"最新大碟"* ||
     "$title_lc" == *"最新專輯"* ||
     "$title_lc" == *"最新专辑"* ||
     "$title_lc" == *"人氣歌曲"* ||
     "$title_lc" == *"人气歌曲"* ||
     "$title_lc" == *"人氣金曲"* ||
     "$title_lc" == *"人气金曲"* ]]
}

reset_ad_candidate() {
  AD_CANDIDATE_KEY=""
  AD_CANDIDATE_COUNT=0
}

confirm_ad_candidate() {
  local reason="$1"
  local key="$2"

  if [[ "$key" == "$AD_CANDIDATE_KEY" ]]; then
    AD_CANDIDATE_COUNT=$((AD_CANDIDATE_COUNT + 1))
  else
    AD_CANDIDATE_KEY="$key"
    AD_CANDIDATE_COUNT=1
  fi

  if ((AD_CANDIDATE_COUNT >= 2)); then
    AD_REASON="$reason"
    return 0
  fi

  return 1
}

is_ad_playing() {
  local status title artist album trackid url
  local title_lc trackid_lc url_lc

  status="$(timeout --foreground "${COMMAND_TIMEOUT}s" playerctl -p spotify status 2>/dev/null || true)"
  if [[ "$status" != "Playing" ]]; then
    reset_ad_candidate
    return 1
  fi

  title="$(metadata_value title)"
  artist="$(metadata_value artist)"
  album="$(metadata_value album)"
  trackid="$(metadata_value mpris:trackid)"
  url="$(metadata_value xesam:url)"

  title_lc="${title,,}"
  trackid_lc="${trackid,,}"
  url_lc="${url,,}"

  if metadata_has_ad_marker "$trackid_lc" "$url_lc"; then
    reset_ad_candidate
    AD_REASON="spotify ad metadata"
    return 0
  fi

  if [[ -n "$title" && -z "$artist" && -z "$album" ]] && title_looks_like_ad "$title_lc"; then
    reset_ad_candidate
    AD_REASON="ad-like title without artist/album metadata: $title"
    return 0
  fi

  if [[ -n "$title" && -z "$artist" && -z "$album" ]] && ! metadata_has_real_media "$trackid_lc" "$url_lc"; then
    if confirm_ad_candidate "missing track identity metadata for: $title" "$title|$trackid|$url"; then
      return 0
    fi
    return 1
  fi

  reset_ad_candidate
  return 1
}

spotify_sink_inputs() {
  local output

  if ! output="$(LC_ALL=C timeout --foreground "${COMMAND_TIMEOUT}s" pactl list sink-inputs 2>&1)"; then
    log "could not list audio streams with pactl: $output"
    return 1
  fi

  awk '
    function emit() {
      if (id != "" && is_spotify) {
        if (mute == "") {
          mute = "no"
        }
        print id, mute
      }
    }

    /^[^[:space:]].*#[0-9]+/ {
      emit()
      match($0, /#[0-9]+/)
      id = substr($0, RSTART + 1, RLENGTH - 1)
      sub(/^#/, "", id)
      is_spotify = 0
      mute = ""
      next
    }

    /^[[:space:]]*Mute:/ {
      mute = $2
      next
    }

    /application\.(name|process\.binary) =/ {
      if (tolower($0) ~ /spotify/) {
        is_spotify = 1
      }
      next
    }

    END {
      emit()
    }
  ' <<< "$output"
}

state_has_sink_input() {
  local id="$1"
  [[ -s "$STATE_FILE" ]] && awk -v id="$id" '$1 == id { found = 1 } END { exit !found }' "$STATE_FILE"
}

record_active_mute() {
  local should_restore_current="$1"
  local marker="preserve-muted"

  if [[ "$should_restore_current" == "yes" ]]; then
    marker="restore-current"
  elif [[ -s "$MUTED_MARKER_FILE" ]]; then
    return 0
  fi

  mkdir -p "$PERSISTENT_STATE_DIR"
  printf '%s\n' "$marker" > "$MUTED_MARKER_FILE"
}

mute_spotify() {
  local inputs id original_mute should_restore_current

  inputs="$(spotify_sink_inputs || true)"
  [[ -n "$inputs" ]] || return 1

  mkdir -p "$STATE_DIR"
  touch "$STATE_FILE"
  should_restore_current="no"

  while read -r id original_mute; do
    [[ -n "$id" ]] || continue
    if [[ "${original_mute:-no}" != "yes" ]]; then
      should_restore_current="yes"
    fi
  done <<< "$inputs"

  record_active_mute "$should_restore_current"

  while read -r id original_mute; do
    [[ -n "$id" ]] || continue

    if ! state_has_sink_input "$id"; then
      printf '%s %s\n' "$id" "${original_mute:-no}" >> "$STATE_FILE"
    fi

    LC_ALL=C timeout --foreground "${COMMAND_TIMEOUT}s" pactl set-sink-input-mute "$id" 1 >/dev/null 2>&1 || true
  done <<< "$inputs"
}

unmute_current_spotify() {
  local inputs id current_mute

  inputs="$(spotify_sink_inputs || true)"
  [[ -n "$inputs" ]] || return 0

  while read -r id current_mute; do
    [[ -n "$id" ]] || continue
    LC_ALL=C timeout --foreground "${COMMAND_TIMEOUT}s" pactl set-sink-input-mute "$id" 0 >/dev/null 2>&1 || true
  done <<< "$inputs"
}

restore_spotify() {
  local id original_mute desired_mute marker should_restore_current

  should_restore_current="no"

  if [[ -s "$MUTED_MARKER_FILE" ]]; then
    read -r marker < "$MUTED_MARKER_FILE" || marker=""
    if [[ "$marker" == "restore-current" ]]; then
      should_restore_current="yes"
    fi
  fi

  if [[ -s "$STATE_FILE" ]]; then
    while read -r id original_mute; do
      [[ -n "$id" ]] || continue

      if [[ "$original_mute" == "yes" ]]; then
        desired_mute=1
      else
        desired_mute=0
        should_restore_current="yes"
      fi

      LC_ALL=C timeout --foreground "${COMMAND_TIMEOUT}s" pactl set-sink-input-mute "$id" "$desired_mute" >/dev/null 2>&1 || true
    done < "$STATE_FILE"

    rm -f "$STATE_FILE"
  fi

  if [[ "$should_restore_current" == "yes" ]]; then
    unmute_current_spotify
  fi

  rm -f "$MUTED_MARKER_FILE"
}

has_active_mute_state() {
  [[ -s "$STATE_FILE" || -s "$MUTED_MARKER_FILE" ]]
}

recover_legacy_stuck_mute() {
  local inputs id current_mute found_muted

  [[ ! -e "$LEGACY_RECOVERY_FILE" ]] || return 0
  has_active_mute_state && return 0
  is_ad_playing && return 0

  inputs="$(spotify_sink_inputs || true)"
  [[ -n "$inputs" ]] || return 0

  found_muted="no"
  while read -r id current_mute; do
    [[ -n "$id" ]] || continue
    if [[ "$current_mute" == "yes" ]]; then
      found_muted="yes"
      break
    fi
  done <<< "$inputs"

  [[ "$found_muted" == "yes" ]] || return 0

  log "found muted Spotify stream without ad-muter state; unmuting once"
  unmute_current_spotify
  mkdir -p "$PERSISTENT_STATE_DIR"
  touch "$LEGACY_RECOVERY_FILE"
}

cleanup() {
  ensure_session_env
  restore_spotify
}

if [[ "${1:-}" == "--restore" ]]; then
  cleanup
  exit 0
fi

shutdown() {
  exit 0
}

trap cleanup EXIT
trap shutdown HUP INT TERM

while true; do
  ensure_session_env

  if ! spotify_available; then
    restore_spotify
    sleep 5
    continue
  fi

  if is_ad_playing; then
    if [[ ! -s "$STATE_FILE" ]]; then
      if mute_spotify; then
        log "ad detected ($AD_REASON); muted Spotify"
      else
        log "ad detected ($AD_REASON); waiting for Spotify audio stream"
      fi
    else
      mute_spotify
    fi
    sleep 1
    continue
  fi

  recover_legacy_stuck_mute

  if has_active_mute_state; then
    log "ad ended; restoring Spotify audio in ${RESUME_DELAY}s"
    sleep "$RESUME_DELAY"
    ensure_session_env

    if is_ad_playing; then
      mute_spotify
      log "another ad is still playing; staying muted"
    else
      restore_spotify
      log "Spotify audio restored"
    fi
  fi

  sleep 1
done
