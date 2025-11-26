{ writeShellScriptBin, nix }:
writeShellScriptBin "gitlab-runner-pre-build-script"
  # bash
  ''
    set -e
    set -u

    function section_start() {
        local name="$1"
        shift
        echo -e "\e[0Ksection_start:$(date +%s):$name[collapsed=true]\r\e[0K$*"
    }

    function section_end() {
        local name="$1"
        echo -e "\e[0Ksection_end:$(date +%s):$name\r\e[0K"
    }

    function setup_nixos() {
        # We need to allow modification of nix config for cachix as
        # otherwise it is link to the read only file in the store.
        cp --remove-destination \
            "$(readlink -f /etc/nix/nix.conf)" /etc/nix/nix.conf

        # shellcheck disable=SC1091
        . "${nix}/etc/profile.d/nix-daemon.sh"
    }

    function setup_non_nixos() {
        # shellcheck disable=SC2174
        {
            echo "Set missing '/nix/var' directories."
            mkdir -p -m 0755 /nix/var/log/nix/drvs
            mkdir -p -m 0755 /nix/var/nix/gcroots
            mkdir -p -m 0755 /nix/var/nix/profiles
            mkdir -p -m 0755 /nix/var/nix/temproots
            mkdir -p -m 0755 /nix/var/nix/userpool
            mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
            mkdir -p -m 1777 /nix/var/nix/profiles/per-user
            mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root

            echo "Set missing '~/.nix-defexpr'."
            mkdir -p -m 0700 ~/.nix-defexpr
        }

        echo "Source 'nix-daemon.sh'."
        # shellcheck disable=SC1091
        . "${nix}/etc/profile.d/nix-daemon.sh"

        echo "Set nix experimental features."
        mkdir -p ~/.config/nix
        touch ~/.config/nix/nix.conf
        echo "experimental-features = nix-command flakes" >>~/.config/nix/nix.conf
    }

    function setup_pipeline_scratch_dir() {
        scratch_dir="/scratch/$CI_PIPELINE_ID"

        echo "Create scratch directory for pipeline: $scratch_dir"
        mkdir -p "$scratch_dir" || {
            echo "Could not create scratch dir '$scratch_dir'." >&2
            exit 1
        }

        export CI_CUSTODIAN_SCRATCH_DIR="$scratch_dir"
    }

    function main() {
        if [ "$IMAGE_OS_DIST" = "ubuntu" ] || [ "$IMAGE_OS_DIST" = "alpine" ]; then
            setup_non_nixos
        elif [ "$IMAGE_OS_DIST" = "nixos" ]; then
            setup_nixos
        else
            echo "OS not implemented."
            exit 1
        fi

        setup_pipeline_scratch_dir
    }

    section_start gitlab-runner-prebuild "Gitlab-Runner PreBuild Script"
    main "$@"
    section_end gitlab-runner-prebuild
  ''
