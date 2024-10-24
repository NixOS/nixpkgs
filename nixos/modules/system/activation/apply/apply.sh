#!@bash@


# This is the NixOS apply script, typically located at
#
# ${config.system.build.toplevel}/bin/apply
#
# This script is responsible for managing the profile link and calling the
# appropriate scripts for its subcommands, such as switch, boot, and test.


set -euo pipefail

toplevel=@toplevel@

subcommand=

installBootloader=
specialisation=
profile=/nix/var/nix/profiles/system

log() {
    echo "$@" >&2
}

die() {
    log "NixOS apply error: $*"
    exit 1
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            switch|boot|test|dry-activate)
                subcommand="$1"
                ;;
            --install-bootloader)
                installBootloader=1
                ;;
            --profile)
                if [[ $# -lt 2 ]]; then
                    die "missing argument for --profile"
                fi
                profile="$2"
                shift
                ;;
            # --rollback is not an `apply` responsibility, and it should be
            # implemented by the caller of `apply` instead.
            --specialisation)
                if [[ $# -lt 2 ]]; then
                    die "missing argument for --specialisation"
                fi
                specialisation="$2"
                shift
                ;;
            *)
                if [[ -n "$subcommand" ]]; then
                    die "unexpected argument or flag: $1"
                else
                    die "unexpected subcommand or flag: $1"
                fi
                ;;
        esac
        shift
    done

    if [ -z "$subcommand" ]; then
        die "no subcommand specified"
    fi
}

main() {
    local cmd activity

    case "$subcommand" in
        boot|switch)
            nix-env -p "$profile" --set "$toplevel"
            ;;
    esac

    # Using systemd-run here to protect against PTY failures/network
    # disconnections during rebuild.
    # See: https://github.com/NixOS/nixpkgs/issues/39118
    cmd=(
        "systemd-run"
        "-E" "LOCALE_ARCHIVE" # Will be set to new value early in switch-to-configuration script, but interpreter starts out with old value
        "-E" "NIXOS_INSTALL_BOOTLOADER=$installBootloader"
        "--collect"
        "--no-ask-password"
        "--pipe"
        "--quiet"
        "--same-dir"
        "--service-type=exec"
        "--unit=nixos-rebuild-switch-to-configuration"
        "--wait"
    )
    # Check if we have a working systemd-run. In chroot environments we may have
    # a non-working systemd, so we fallback to not using systemd-run.
    if ! "${cmd[@]}" true; then
        log "Skipping systemd-run to switch configuration since it is not working in target host."
        cmd=(
            "env"
            "-i"
            "LOCALE_ARCHIVE=${LOCALE_ARCHIVE:-}"
            "NIXOS_INSTALL_BOOTLOADER=$installBootloader"
        )
    fi
    if [[ -z "$specialisation" ]]; then
        cmd+=("$toplevel/bin/switch-to-configuration")
    else
        cmd+=("$toplevel/specialisation/$specialisation/bin/switch-to-configuration")

        if ! [[ -f "${cmd[-1]}" ]]; then
            log "error: specialisation not found: $specialisation"
            exit 1
        fi
    fi

    if ! "${cmd[@]}" "$subcommand"; then
        case "$subcommand" in
            switch)
                activity="switching to the new configuration"
                ;;
            boot)
                activity="switching the boot entry to the new configuration"
                ;;
            test)
                activity="switching to the new configuration (in test mode)"
                ;;
            dry-activate)
                activity="switching to the new configuration (in dry-activate mode)"
                ;;
            *)  # Should never happen
                activity="running $subcommand"
                ;;
        esac
        log "warning: error(s) occurred while $activity"
        exit 1
    fi
}

if ! type test_run_tests &>/dev/null; then
    # We're not loaded into the test.sh, so we run main.
    parse_args "$@"
    main
fi
