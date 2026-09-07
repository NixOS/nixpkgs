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

    function setup() {
        # We need to allow modification of nix config for cachix as
        # otherwise it is link to the read only file in the store.
        cp --remove-destination \
            "$(readlink -f /etc/nix/nix.conf)" /etc/nix/nix.conf

        # shellcheck disable=SC1091
        . "${nix}/etc/profile.d/nix-daemon.sh"
    }

    function setup_pipeline_scratch_dir() {
        scratch_dir="/scratch/$CI_PIPELINE_ID"

        echo "Create scratch directory for pipeline: $scratch_dir"
        mkdir -p "$scratch_dir" || {
            echo "Could not create scratch dir '$scratch_dir'." >&2
            exit 1
        }

        export CI_CUSTOM_SCRATCH_DIR="$scratch_dir"
    }

    function print_info() {
      echo "Nix version:"
      nix --version
    }

    function main() {
        print_info
        setup
        setup_pipeline_scratch_dir
    }

    section_start gitlab-runner-prebuild "Gitlab-Runner PreBuild Script"
    main "$@"
    section_end gitlab-runner-prebuild
  ''
