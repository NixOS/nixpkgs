{ config, lib, pkgs, ... }:

with lib;

let
  format = pkgs.formats.json { };
  commonOptions = { pkgName, flavour ? pkgName }: mkOption {
    default = { };
    description = ''
      Attribute set of ${flavour} instances.
      Creates independent `${flavour}-''${name}.service` systemd units for each instance defined here.
    '';
    type = with types; attrsOf (submodule ({ name, ... }: {
      options = {
        enable = mkEnableOption "this ${flavour} instance" // { default = true; };

        package = mkPackageOption pkgs pkgName { };

        user = mkOption {
          type = types.str;
          default = "root";
          description = ''
            User under which this instance runs.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "root";
          description = ''
            Group under which this instance runs.
          '';
        };

        settings = mkOption {
          type = types.submodule {
            freeformType = format.type;

            options = {
              pid_file = mkOption {
                default = "/run/${flavour}/${name}.pid";
                type = types.str;
                description = ''
                  Path to use for the pid file.
                '';
              };

              template = mkOption {
                default = null;
                type = with types; nullOr (listOf (attrsOf anything));
                description =
                  let upstreamDocs =
                    if flavour == "vault-agent"
                    then "https://developer.hashicorp.com/vault/docs/agent/template"
                    else "https://github.com/hashicorp/consul-template/blob/main/docs/configuration.md#templates";
                  in ''
                    Template section of ${flavour}.
                    Refer to <${upstreamDocs}> for supported values.
                  '';
              };
            };
          };

          default = { };

          description =
            let upstreamDocs =
              if flavour == "vault-agent"
              then "https://developer.hashicorp.com/vault/docs/agent#configuration-file-options"
              else "https://github.com/hashicorp/consul-template/blob/main/docs/configuration.md#configuration-file";
            in ''
              Free-form settings written directly to the `config.json` file.
              Refer to <${upstreamDocs}> for supported values.

              ::: {.note}
              Resulting format is JSON not HCL.
              Refer to <https://www.hcl2json.com/> if you are unsure how to convert HCL options to JSON.
              :::
            '';
        };
      };
    }));
  };

  createAgentInstance = { instance, name, flavour }:
    let
      configFile = format.generate "${name}.json" instance.settings;
    in
    mkIf (instance.enable) {
      description = "${flavour} daemon - ${name}";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.getent ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      serviceConfig = {
        User = instance.user;
        Group = instance.group;
        RuntimeDirectory = flavour;
        ExecStart = "${getExe instance.package} ${optionalString ((getName instance.package) == "vault") "agent"} -config ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
      };
    };
in
{
  options = {
    services.consul-template.instances = commonOptions { pkgName = "consul-template"; };
    services.vault-agent.instances = commonOptions { pkgName = "vault"; flavour = "vault-agent"; };
  };

  config = mkMerge (map
    (flavour:
      let cfg = config.services.${flavour}; in
      mkIf (cfg.instances != { }) {
        systemd.services = mapAttrs'
          (name: instance: nameValuePair "${flavour}-${name}" (createAgentInstance { inherit name instance flavour; }))
          cfg.instances;
      })
    [ "consul-template" "vault-agent" ]);

  meta.maintainers = with maintainers; [ emilylange tcheronneau ];
}

