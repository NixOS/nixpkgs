{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (types) str;
in
{
  meta = {
    description = ''
      Contract for secrets handling where a consumer requests a secret
      and a provider provides it at runtime at a given file path.
    '';
    maintainers = with lib.maintainers; [
      ibizaman
      kiara
    ];
  };
  interface = {
    request = {
      mode = mkOption {
        description = ''
          Mode the secret file must have.
        '';
        type = str;
        default = "0400";
      };

      owner = mkOption {
        description = ''
          Linux user that must own the secret file.
        '';
        type = str;
      };

      group = mkOption {
        description = ''
          Linux group that must own the secret file.
        '';
        type = str;
      };
    };
    result = {
      path = mkOption {
        type = str;
        description = ''
          Path to the file containing the secret generated out of band.

          This path will exist after deploying to a target host,
          it is not available through the nix store.
        '';
      };
    };
  };
  behaviorTest =
    {
      name,
      providerRoot,
      extraModules ? [ ],
    }:
    {
      name = "contracts_filesecrets_${name}";
      containers.machine =
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
              request = {
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
        { containers, ... }:
        let
          cfg = containers.machine;
          inherit (lib.getAttrFromPath providerRoot containers.machine) result;
        in
        ''
          owner = machine.succeed("stat -c '%U' ${result.path}").strip()
          print(f"Got owner {owner}")
          if owner != "${cfg.test.owner}":
              raise Exception(f"Owner should be '${cfg.test.owner}' but got '{owner}'")

          group = machine.succeed("stat -c '%G' ${result.path}").strip()
          print(f"Got group {group}")
          if group != "${cfg.test.group}":
              raise Exception(f"Group should be '${cfg.test.group}' but got '{group}'")

          mode = str(int(machine.succeed("stat -c '%a' ${result.path}").strip()))
          print(f"Got mode {mode}")
          wantedMode = str(int("${cfg.test.mode}"))
          if mode != wantedMode:
              raise Exception(f"Mode should be '{wantedMode}' but got '{mode}'")

          content = machine.succeed("cat ${result.path}").strip()
          print(f"Got content {content}")
          if content != "${cfg.test.content}":
              raise Exception(f"Content should be '${cfg.test.content}' but got '{content}'")
        '';
    };
}
