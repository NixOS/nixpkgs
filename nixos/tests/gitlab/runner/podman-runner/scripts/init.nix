# Profile scripts which is sourced.
{
  lib,
  writeShellScriptBin,
  nix,
  gosu,
}:
let
  # This script is sourced in the prebuild script
  # `prebuild.nix`.
  profileFn =
    # bash
    ''
      function profile() {
        [ -z "''${__USER_PROFILE_SOURCED:-}" ] || {
          echo "Profile script already sourced."
          return 0
        }

        echo "User: '$(id)'"
        export USER="$(id -n -u)"

        if [ -z "''${HOME:-}" ]; then
          if [ "$USER" == "root" ]; then
            export HOME="/root"
          else
            export HOME="/home/$USER"
          fi
        fi
        echo "Home: '$HOME'."

        echo "Sourcing '${nix}/etc/profile.d/nix-daemon.sh'"
        . "${nix}/etc/profile.d/nix-daemon.sh"

        echo "Define XDG dirs."
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_STATE_HOME="$HOME/.local/state"

        export __USER_PROFILE_SOURCED=true
      }
    '';

  profile =
    writeShellScriptBin "profile-script"
      # bash
      ''
        ${profileFn}
        # Wrap all stdout to err, due to safety
        # of capturing stdout.
        profile 1>&2
        unset profile
      '';

  profileExec =
    writeShellScriptBin "profile-exec"
      # bash
      ''
        set -eu -o pipefail

        ${profileFn}
        profile

        exec "$@"
      '';

  # This script for the entrypoint in the containers.
  # Special env. variables which are
  #
  # - `CONTAINER_USERSPEC` is a user specification in form 'UID:GID' (e.g. `ci:ci`).
  #    which will switch the command to execute the command as the given user/group.
  entrypoint =
    writeShellScriptBin "entrypoint-script"
      # bash
      ''
        USERSPEC="''${CONTAINER_USERSPEC:-}" # A user spec in form 'UID:GID'.
        unset CONTAINER_USERSPEC

        ${profileFn}

        function chown_for_user() {
          if [ "$(id -u)" != 0 ]; then
            if [ "''${CI:-}" = "true" ]; then
              echo "ERROR: You must not run this image in CI"
              echo "       with a user other than 'root', cause it circumvents the entrypoint!"
              exit 1
            else
              echo "WARNING: You run this image not with root which circumvents the"
              echo "         entrypoint handling for the env. var 'USERSPEC'."
            fi
          fi

          if [ -n "$USERSPEC" ]; then
            if [ "$(id -u)" != 0 ]; then
              echo "ERROR: Cannot switch to user '$USERSPEC'. Need to be root!"
              exit 1
            fi

            if [ -d "$CI_PROJECT_DIR" ]; then
              echo "Chowning 'CI_PROJECT_DIR=$CI_PROJECT_DIR' to '$USERSPEC'."
              chown -R "$USERSPEC" "$CI_PROJECT_DIR"
            else
              echo "WARNING: No directory 'CI_PROJECT_DIR=$CI_PROJECT_DIR' to chown."
            fi
          fi
        }

        function dispatch() {
          if [ -n "$USERSPEC" ]; then
            echo "Switching to user '$USERSPEC'."
            "${lib.getExe gosu}" "$USERSPEC" "${lib.getExe profileExec}" "$@"
          else
            "${lib.getExe profileExec}" "$@"
          fi
        }

        chown_for_user >&2
        dispatch "$@" >&2
      '';

in
{
  inherit entrypoint profile;
}
