{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str path;
in
{
  contracts.secret = {
    meta = {
      maintainers = [ lib.maintainers.ibizaman ];
      description = ''
        Contract for secrets handling where a consumer requests a secret
        and a provider provides it at runtime at a given file path.
      '';
    };

    input = {
      options.mode = mkOption {
        description = ''
          Mode of the secret file.
        '';
        type = str;
      };

      options.owner = mkOption {
        description = ''
          Linux user owning the secret file.
        '';
        type = str;
      };

      options.group = mkOption {
        description = ''
          Linux group owning the secret file.
        '';
        type = str;
      };
    };

    output = {
      options.path = mkOption {
        type = path;
        description = ''
          Path to the file containing the secret generated out of band.

          This path will exist after deploying to a target host,
          it is not available through the nix store.
        '';
      };
    };

    behaviorTest =
      {
        providerRoot,
        extraModules ? [ ],
      }:
      {
        nodes.machine =
          { config, ... }:
          {
            imports = extraModules;

            options.test = {
              owner = mkOption {
                type = str;
                default = "root";
              };

              group = mkOption {
                type = str;
                default = "root";
              };

              mode = mkOption {
                type = str;
                default = "0400";
              };

              content = mkOption {
                type = str;
                default = "a super secret secret!";
              };
            };

            config = lib.mkMerge [
              (lib.setAttrByPath providerRoot {
                # We set consumer.input and not input directly because the latter is readOnly.
                consumer.input = {
                  inherit (config.test) owner group mode;
                };
              })
              (lib.mkIf (config.test.owner != "root") {
                users.users.${config.test.owner}.isNormalUser = true;
              })
              (lib.mkIf (config.test.group != "root") {
                users.groups.${config.test.group} = { };
              })
            ];
          };

        testScript =
          { nodes, ... }:
          let
            cfg = nodes.machine;
            inherit (lib.getAttrFromPath providerRoot nodes.machine) output;
          in
          ''
            owner = machine.succeed("stat -c '%U' ${output.path}").strip()
            print(f"Got owner {owner}")
            if owner != "${cfg.test.owner}":
                raise Exception(f"Owner should be '${cfg.test.owner}' but got '{owner}'")

            group = machine.succeed("stat -c '%G' ${output.path}").strip()
            print(f"Got group {group}")
            if group != "${cfg.test.group}":
                raise Exception(f"Group should be '${cfg.test.group}' but got '{group}'")

            mode = str(int(machine.succeed("stat -c '%a' ${output.path}").strip()))
            print(f"Got mode {mode}")
            wantedMode = str(int("${cfg.test.mode}"))
            if mode != wantedMode:
                raise Exception(f"Mode should be '{wantedMode}' but got '{mode}'")

            content = machine.succeed("cat ${output.path}").strip()
            print(f"Got content {content}")
            if content != "${cfg.test.content}":
                raise Exception(f"Content should be '${cfg.test.content}' but got '{content}'")
          '';
      };
  };
}
