#!/usr/bin/env bash
set -eEuo pipefail
test -z "${DEBUG:-}" || set -x
set -eEuo pipefail

FIRMWARE_PATH="${EDID_PATH:-"/run/current-system/firmware"}"
mapfile -t edid_paths <<<"${FIRMWARE_PATH//":"/$'\n'}"

err() {
  LOGGER="ERROR" log "$@"
  return 1
}

log() {
  # shellcheck disable=SC2059
  printf "[${LOGGER:-"INFO"}] $1\n" "${@:2}" >&2
}

find_path() {
  local filePath="$1"
  mapfile -t candidates < <(
    set -x
    find -L "${@:2}" -path "*/${filePath}"
  )
  if test "${#candidates[@]}" -eq 0; then
    log "'%s' path not found" "${filePath}"
    return 1
  fi
  log "'%s' path found at %s" "${filePath}" "${candidates[0]}"
  echo -n "${candidates[0]}"
}

wait_for_file() {
  local filePath="$1"
  until find_path "${filePath}" "${@:2}"; do
    backoff "${filePath}"
  done
}

backoff() {
  local what="$1" sleepFor

  backoff_start="${backoff_start:-"5"}"
  backoff_current="${backoff_current:-"${backoff_start}"}"
  backoff_jitter_multiplier="${backoff_jitter_multiplier:-"0.3"}"
  backoff_multiplier="${backoff_multiplier:-1.5}"

  sleepFor="$(bc <<<"${backoff_current} + ${RANDOM} % (${backoff_current} * ${backoff_jitter_multiplier})")"

  log "still waiting for '%s', retry in %s sec..." "${what}" "${sleepFor}"
  sleep "${sleepFor}"
  backoff_current="$(bc <<<"scale=2; ${backoff_current} * ${backoff_multiplier}")"

}

force_mode() {
  local connPath="$1" newMode="$2" currentMode
  currentMode="$(cat "$connPath/force")"
  if test "${currentMode}" == "${newMode}"; then
    log "video mode is already '%s'" "${currentMode}"
    return
  fi
  log "changing video mode from '%s' to '%s'" "${currentMode}" "${newMode}"
  echo "${newMode}" >"$connPath/force"
  CHANGED=1
}

force_edid() {
  local connPath="$1" edidPath="$2"
}

apply_mode() {
  local connPath="$1" mode="$2"
  test -n "$mode" || return
  log "setting up fb mode..."

  # see https://github.com/torvalds/linux/blob/8cd26fd90c1ad7acdcfb9f69ca99d13aa7b24561/drivers/gpu/drm/drm_sysfs.c#L202-L207
  # see https://docs.kernel.org/fb/modedb.html
  case "${mode}" in
  *d) force_mode "$connPath" off ;;
  *e) force_mode "$connPath" on ;;
  *D) force_mode "$connPath" on-digital ;;
  esac
}

apply_edid() {
  local connPath="$1" edidFilename="$2" edidPath
  test -n "${edidFilename}" || return
  log "loading EDID override..."
  edidPath="$(find_path "${edidFilename}" "${edid_paths[@]/%/"/"}" -maxdepth 2)"

  force_edid "${connPath}" "$edidPath"
  cat "$edidPath" >"${connPath}/edid_override"

  if cmp "${connPath}/edid_override" "${edidPath}" &>/dev/null; then
    log "EDID is already up to date with '%s'" "${edidPath}"
  else
    log "applying EDID override from ${edidPath}"
    cat "$edidPath" >"${connPath}/edid_override"
    CHANGED=1
  fi
}

load() {
  local conn="$1" edidFilename="$2" mode="$3"
  export LOGGER="$conn:${edidFilename}:$mode"
  CHANGED="${CHANGED:-0}"

  log "starting configuration"
  local connPath
  connPath="$(wait_for_file "$conn" /sys/kernel/debug/dri/ -maxdepth 2 -type d)"
  apply_edid "${connPath}" "${edidFilename}"
  apply_mode "${connPath}" "$mode"

  if test "${CHANGED}" != 0; then
    log "changes detected, triggering hotplug"
    echo 1 >"${connPath}/trigger_hotplug"
  else
    log "no changes detected, skipping hotplug trigger"
  fi
}

main() {
  if [[ $EUID -ne 0 ]]; then
    err "must be run as root"
  fi

  if test "$#" == 0; then
    log "loading kernel parameters from /proc/cmdline"
    # replace script arguments with kernel parameters
    mapfile -t args < <(xargs -n1 </proc/cmdline)
  else
    log "loading kernel parameters compatible arguments from commandline"
    args=("$@")
  fi

  local -A edids modes connectors
  local -a entries
  local key value

  for arg in "${args[@]}"; do
    key="${arg%%=*}"
    value=""
    test "${key}" == "${arg}" || value="${arg#*=}"

    case "${key}" in
    video)
      # one argument per connector:
      #   video=DP-4:e video=DP-1:e
      connector="${value%:*}"
      mode="${value#*:}"
      connectors["${connector}"]=""
      modes["$connector"]="$mode"
      ;;
    drm.edid_firmware)
      # single argument for all connectors:
      #   drm.edid_firmware=DP-4:edid/one.bin,DP-1:edid/two.bin
      mapfile -t entries <<<"${value//","/$'\n'}"
      for entry in "${entries[@]}"; do
        connector="${entry%:*}"
        edidFilename="${entry#*:}"
        connectors["${connector}"]=""
        edids["${connector}"]="${edidFilename}"
      done
      ;;
    esac
  done

  for connector in "${!connectors[@]}"; do
    # spawn in a subshell to easily adjust and runtime modify global variables
    (load "${connector}" "${edids["${connector}"]:-""}" "${modes["${connector}"]:-""}") &
  done
  wait
}

main "$@"
