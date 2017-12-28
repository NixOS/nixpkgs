{ config, lib, pkgs, ... }:

with lib;

let
  ## isPath :: String -> Bool
  isPath = x: !(isAttrs x || isList x || isFunction x || isString x || isInt x || isBool x || isNull x)
               || (isString x && builtins.substring 0 1 x == "/");

  cfg = config.services.buildkite-agent;
in

{
  options = {
    services.buildkite-agent = {
      enable = mkEnableOption "buildkite-agent";

      token = mkOption {
        type = types.either types.str types.path;
        description = ''
          The token from your Buildkite "Agents" page.

          Either a literal string value, or a path to the token file.
        '';
      };

      name = mkOption {
        type = types.str;
        description = ''
          The name of the agent.
        '';
      };

      hooksPath = mkOption {
        type = types.path;
        default = "${pkgs.buildkite-agent}/share/hooks";
        defaultText = "${pkgs.buildkite-agent}/share/hooks";
        description = ''
          Path to the directory storing the hooks.
        '';
      };

      meta-data = mkOption {
        type = types.str;
        default = "";
        description = ''
          Meta data for the agent.
        '';
      };

      openssh =
        { privateKey = mkOption {
            type = types.either types.str types.path;
            description = ''
              Private agent key.

              Either a literal string value, or a path to the token file.
            '';
          };
          publicKey = mkOption {
            type = types.either types.str types.path;
            description = ''
              Public agent key.

              Either a literal string value, or a path to the token file.
            '';
          };
        };
    };
  };

  config = mkIf config.services.buildkite-agent.enable {
    users.extraUsers.buildkite-agent =
      { name = "buildkite-agent";
        home = "/var/lib/buildkite-agent";
        createHome = true;
        description = "Buildkite agent user";
        extraGroups = [ "keys" ];
      };

    environment.systemPackages = [ pkgs.buildkite-agent ];

    systemd.services.buildkite-agent =
      let copyOrEcho       = x: target: perms:
                             (if isPath x
                              then "cp -f ${x} ${target}; "
                              else "echo '${x}' > ${target}; ")
                             + "${pkgs.coreutils}/bin/chmod ${toString perms} ${target}; ";
          catOrLiteral     = x:
                             (if isPath x
                              then "$(cat ${toString x})"
                              else "${x}");
      in
      { description = "Buildkite Agent";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        environment.HOME = "/var/lib/buildkite-agent";

        ## NB: maximum care is taken so that secrets (ssh keys and the CI token)
        ##     don't end up in the Nix store.
        preStart = ''
            ${pkgs.coreutils}/bin/mkdir -m 0700 -p /var/lib/buildkite-agent/.ssh
            ${copyOrEcho (toString cfg.openssh.privateKey) "/var/lib/buildkite-agent/.ssh/id_rsa"     600}
            ${copyOrEcho (toString cfg.openssh.publicKey)  "/var/lib/buildkite-agent/.ssh/id_rsa.pub" 600}

            cat > "/var/lib/buildkite-agent/buildkite-agent.cfg" <<EOF
            token="${catOrLiteral cfg.token}"
            name="${cfg.name}"
            meta-data="${cfg.meta-data}"
            hooks-path="${toString cfg.hooksPath}"
            build-path="/var/lib/buildkite-agent/builds"
            bootstrap-script="${pkgs.buildkite-agent}/share/bootstrap.sh"
            EOF
          '';

        serviceConfig =
          { ExecStart = "${pkgs.buildkite-agent}/bin/buildkite-agent start --config /var/lib/buildkite-agent/buildkite-agent.cfg";
            User = "buildkite-agent";
            RestartSec = 5;
            Restart = "on-failure";
            TimeoutSec = 10;
          };
      };
  };
}
