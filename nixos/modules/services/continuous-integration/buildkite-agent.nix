{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildkite-agent;

  mkHookOption = { name, description, example ? null }: {
    inherit name;
    value = mkOption {
      default = null;
      inherit description;
      type = types.nullOr types.lines;
    } // (if example == null then {} else { inherit example; });
  };
  mkHookOptions = hooks: listToAttrs (map mkHookOption hooks);

  hooksDir = let
    mkHookEntry = name: value: ''
      cat > $out/${name} <<'EOF'
      #! ${pkgs.runtimeShell}
      set -e
      ${value}
      EOF
      chmod 755 $out/${name}
    '';
  in pkgs.runCommand "buildkite-agent-hooks" { preferLocalBuild = true; } ''
    mkdir $out
    ${concatStringsSep "\n" (mapAttrsToList mkHookEntry (filterAttrs (n: v: v != null) cfg.hooks))}
  '';

in

{
  options = {
    services.buildkite-agent = mkOption {
      description = ''
        Options passed to buildkite-agents.
      '';
      default = {};
    };
  };

  config = mkIf (config.services.buildkite-agent.enable or false) {
    services.buildkite-agents."" = cfg;
  };
  imports = [
    (mkRenamedOptionModule [ "services" "buildkite-agent" "token" ]                [ "services" "buildkite-agent" "tokenPath" ])
    (mkRenamedOptionModule [ "services" "buildkite-agent" "openssh" "privateKey" ] [ "services" "buildkite-agent" "openssh" "privateKeyPath" ])
    (mkRenamedOptionModule [ "services" "buildkite-agent" "openssh" "privateKeyPath" ] [ "services" "buildkite-agent" "sshKeyPath" ])
  ];
}
