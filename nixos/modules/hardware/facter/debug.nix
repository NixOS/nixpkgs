{
  lib,
  pkgs,
  config,
  extendModules,
  ...
}:
{

  options = {

    system.build = {
      noFacter = lib.mkOption {
        type = lib.types.unspecified;
        description = "A version of the system closure with facter disabled";
      };
    };

    hardware.facter.debug = {
      nvd = lib.mkOption {
        type = lib.types.package;
        description = ''
          A shell application which will produce an nvd diff of the system closure with and without facter enabled.
        '';
      };
      nix-diff = lib.mkOption {
        type = lib.types.package;
        description = ''
          A shell application which will produce a nix-diff of the system closure with and without facter enabled.
        '';
      };
      changes = lib.mkOption {
        type = lib.types.package;
        description = ''
          A shell application which will print final values alongside facter contributions.
        '';
      };
    };

  };

  config.system.build = {
    noFacter = extendModules {
      modules = [
        {
          # we 'disable' facter by overriding the report and setting it to empty with one caveat: hostPlatform
          config.hardware.facter.report = lib.mkForce {
            system = config.nixpkgs.hostPlatform;
          };
        }
      ];
    };
  };

  config.hardware.facter.debug = {

    nvd = pkgs.writeShellApplication {
      name = "facter-nvd-diff";
      runtimeInputs = [
        config.nix.package
        pkgs.nvd
      ];
      text = ''
        nvd diff \
          ${config.system.build.noFacter.config.system.build.toplevel} \
          ${config.system.build.toplevel} \
          "$@"
      '';
    };

    nix-diff = pkgs.writeShellApplication {
      name = "facter-nix-diff";
      runtimeInputs = [
        config.nix.package
        pkgs.nix-diff
      ];
      text = ''
        nix-diff \
          ${config.system.build.noFacter.config.system.build.toplevel} \
          ${config.system.build.toplevel} \
          "$@"
      '';
    };

    changes = pkgs.writeShellApplication {
      name = "facter-changes";
      runtimeInputs = [
        config.nix.package
        pkgs.jq
      ];
      text = ''
        set -euo pipefail

        usage() {
          cat <<'EOF'
        Usage:
          facter-changes <flake-config-ref>
          facter-changes -I nixos-config=./configuration.nix [nix-instantiate args...]

        Examples:
          facter-changes .#nixosConfigurations.badxps
          facter-changes -I nixos-config=./configuration.nix
        EOF
        }

        is_flake_ref() {
          case "$1" in
            *'#'*|/*|git+file:*|path:*)
              return 0
              ;;
            *)
              return 1
              ;;
          esac
        }

        normalize_flake_target() {
          local target="$1"
          local suffix=".config.hardware.facter.debug.changes"

          if [ "''${target%"$suffix"}" != "$target" ]; then
            printf '%s\n' "''${target%"$suffix"}"
          else
            printf '%s\n' "$target"
          fi
        }

        eval_flake_value() {
          local target="$1"
          local option="$2"
          nix eval --json "''${target}.config.''${option}" 2>/dev/null
        }

        eval_flake_changes() {
          local target="$1"
          nix eval --json "''${target}.config.hardware.facter.changes"
        }

        eval_legacy_value() {
          local option="$1"
          shift
          nix-instantiate '<nixpkgs/nixos>' \
            --eval \
            --strict \
            --json \
            -A "config.''${option}" \
            "$@" 2>/dev/null
        }

        eval_legacy_changes() {
          nix-instantiate '<nixpkgs/nixos>' \
            --eval \
            --strict \
            --json \
            -A config.hardware.facter.changes \
            "$@"
        }

        if [ "$#" -eq 0 ]; then
          usage >&2
          exit 1
        fi

        mode=""
        flake_target=""
        legacy_args=()

        if is_flake_ref "$1"; then
          mode="flake"
          flake_target="$(normalize_flake_target "$1")"
          shift

          if [ "$#" -ne 0 ]; then
            echo "facter-changes: unexpected extra arguments in flake mode" >&2
            usage >&2
            exit 1
          fi
        else
          mode="legacy"
          legacy_args=("$@")
        fi

        if [ "$mode" = "flake" ]; then
          changes_json="$(eval_flake_changes "$flake_target")"
        else
          changes_json="$(eval_legacy_changes "''${legacy_args[@]}")"
        fi

        jq -c 'to_entries[]' <<<"$changes_json" | while IFS= read -r entry; do
          option="$(jq -r '.key' <<<"$entry")"
          desired_json="$(jq -c '.value' <<<"$entry")"

          if [ "$mode" = "flake" ]; then
            if effective_json="$(eval_flake_value "$flake_target" "$option")"; then
              :
            else
              effective_json="<unavailable>"
            fi
          else
            if effective_json="$(eval_legacy_value "$option" "''${legacy_args[@]}")"; then
              :
            else
              effective_json="<unavailable>"
            fi
          fi

          if [ "$(jq -r 'type' <<<"$desired_json")" = "object" ]; then
            jq -r 'to_entries[] | "# facter \(.key) = \(.value | tojson)"' <<<"$desired_json"
          else
            printf '# facter %s = %s\n' "$option" "$desired_json"
          fi

          if [ "$effective_json" = "<unavailable>" ]; then
            printf '%s = <unavailable>\n' "$option"
          else
            printf '%s = %s\n' "$option" "$effective_json"
          fi

          printf '\n'
        done
      '';
    };

  };

}
