# This shell library is used by both
#   - The nixos-rebuild package: for applying configurations that pre-date the toplevel/bin/apply script
#   - toplevel/bin/apply: the normal script for applying configurations
#   - system.build.apply: same script but not incorporated into toplevel (it's a tradeoff)
#
# Relevant tests:
#   - nixos-rebuild.tests
#   - TBD

# TODO: Test deploying a legacy config in a NixOS test. Remove `bin/apply` using override? Or add an internal option to avoid adding `apply`?
# TODO: Move the documentation to the manual
# TODO: Is it ok for action=test not to produce a result symlink? It's undocumented and might have been a mistake that's been cautiously preserved.
#       I would consider it to be a bug. A surprise result symlink will be a GC root that the user is unaware of, taking up space.
# TODO: Canonicalize pathToConfig with readlink for consistency? Currently rollbacks make them point to the profile symlink instead.
# TODO: Test --target-host

# Run $action
#
# Prerequisites:
#  - $action: The switch-to-configuration subcommand (ie boot|switch|boot|dry-activate)
#  - $pathToConfig: The toplevel, or the special string "rollback"
#  - $profile: The profile location
#  - targetHostCmd: A function that runs a command on the target host. This is
#    an artefact of legacy configuration support, where we can't just invoke bin/apply
#    New deployment methods should just ssh once and invoke bin/apply directly.
#      - e.g. for local execution: targetHostCmd(){ "$@"; }
#      - see nixos-rebuild
nixos_apply_run_action() {

    if [[ "$pathToConfig" == rollback ]]; then
        if [[ "$action" == switch || "$action" == test ]]; then
            targetHostCmd nix-env -p "$profile" --rollback
            pathToConfig="$profile"
        else
            systemNumber=$(
                targetHostCmd nix-env -p "$profile" --list-generations |
                sed -n '/current/ {g; p;}; s/ *\([0-9]*\).*/\1/; h'
            )
            pathToConfig="$profile"-${systemNumber}-link
        fi

    else # [[ -n "$rollback" ]]
        targetHostCmd nix-env -p "$profile" --set "$pathToConfig"
    fi

    # Using systemd-run here to protect against PTY failures/network
    # disconnections during rebuild.
    # See: https://github.com/NixOS/nixpkgs/issues/39118
    cmd=(
        "systemd-run"
        "-E" "LOCALE_ARCHIVE" # Will be set to new value early in switch-to-configuration script, but interpreter starts out with old value
        "-E" "NIXOS_INSTALL_BOOTLOADER"
        "--collect"
        "--no-ask-password"
        "--pty"
        "--quiet"
        "--same-dir"
        "--service-type=exec"
        "--unit=nixos-rebuild-switch-to-configuration"
        "--wait"
    )
    # Check if we have a working systemd-run. In chroot environments we may have
    # a non-working systemd, so we fallback to not using systemd-run.
    # You may also want to explicitly set NIXOS_SWITCH_USE_DIRTY_ENV environment
    # variable, since systemd-run runs inside an isolated environment and
    # this may break some post-switch scripts. However keep in mind that this
    # may be dangerous in remote access (e.g. SSH).
    if [[ -n "$NIXOS_SWITCH_USE_DIRTY_ENV" ]]; then
        log "warning: skipping systemd-run since NIXOS_SWITCH_USE_DIRTY_ENV is set. This environment variable will be ignored in the future"
        cmd=()
    elif ! targetHostCmd "${cmd[@]}" true &>/dev/null; then
        logVerbose "Skipping systemd-run to switch configuration since it is not working in target host."
        cmd=(
            "env"
            "-i"
            "LOCALE_ARCHIVE=$LOCALE_ARCHIVE"
            "NIXOS_INSTALL_BOOTLOADER=$NIXOS_INSTALL_BOOTLOADER"
        )
    else
        logVerbose "Using systemd-run to switch configuration."
    fi
    if [[ -z "$specialisation" ]]; then
        cmd+=("$pathToConfig/bin/switch-to-configuration")
    else
        cmd+=("$pathToConfig/specialisation/$specialisation/bin/switch-to-configuration")

        if [[ ! -f "${cmd[-1]}" ]]; then
            log "error: specialisation not found: $specialisation"
            exit 1
        fi
    fi

    if ! targetHostCmd "${cmd[@]}" "$action"; then
        log "warning: error(s) occurred while switching to the new configuration"
        exit 1
    fi
}