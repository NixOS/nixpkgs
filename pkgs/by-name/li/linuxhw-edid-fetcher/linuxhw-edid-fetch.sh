#!/usr/bin/env bash
set -eEuo pipefail
test -z "${DEBUG:-}" || set -x
# based on instructions provided in https://github.com/linuxhw/EDID/blob/98bc7d6e2c0eaad61346a8bf877b562fee16efc3/README.md

usage() {
    cat <<EOF >&2
Usage:
  ${BASH_SOURCE[0]} PG278Q 2014 >edid.bin
  repo=/path/to/linuxhw/EDID ${BASH_SOURCE[0]} PG278Q 2014 >edid.bin

verify the generated file:
  edid-decode <edid.bin
  parse-edid <edid.bin

load the generated file:
  cat edid.bin >/sys/kernel/debug/dri/0/DP-1/edid_override
EOF
}

log() {
    # shellcheck disable=SC2059
    printf "${1}\n" "${@:2}" >&2
}

find_displays() {
    local script=("BEGIN { IGNORECASE=1 } /${1}/")

    for pattern in "${@:2}"; do
        script+=('&&' "/${pattern}/")
    done
    cat "${repo}"/{Analog,Digital}Display.md | awk "${script[*]}"
}

to_edid() {
    if ! test -e "$1"; then
        log "EDID specification file $1 does not exist,"
        log "it is most likely an error with https://github.com/linuxhw/EDID"
        return 1
    fi

    log "Extracting $1..."

    # https://github.com/linuxhw/EDID/blob/228fea5d89782402dd7f84a459df7f5248573b10/README.md#L42-L42
    grep -E '^([a-f0-9]{32}|[a-f0-9 ]{47})$' <"$1" | tr -d '[:space:]' | xxd -r -p
}

extract_link() {
    awk '{ gsub(/^.+]\(</, ""); gsub(/>).+/, ""); print }'
}

check_repo() {
    test -d "$1" && test -f "$1/AnalogDisplay.md" && test -f "$1/DigitalDisplay.md"
}

main() {
    if [[ $# == 0 ]]; then
        usage
        exit 1
    fi

    : "${repo:="$PWD"}"

    if ! check_repo "$repo"; then
        repo="${TMPDIR:-/tmp}/edid"
        log "Not running inside 'https://github.com/linuxhw/EDID', downloading content to ${repo}"
        if ! check_repo "$repo"; then
            curl -L https://github.com/linuxhw/EDID/tarball/HEAD | tar -zx -C "${repo}" --strip-components=1
        fi
    fi

    log "Using repository at ${repo}"

    readarray -t lines < <(find_displays "${@}")
    case "${#lines[@]}" in
    0)
        log "No matches, try broader patterns?"
        exit 1
        ;;
    1)
        log "Matched entries:"
        log "> %s" "${lines[@]}"
        log "Found exactly one pattern, continuing..."
        ;;
    *)
        log "Matched entries:"
        log "> %s" "${lines[@]}"
        log "More than one match, make patterns more specific until there is only one left"
        exit 2
        ;;
    esac

    to_edid "${repo}/$(extract_link <<<"${lines[0]}")"
}

main "$@"
