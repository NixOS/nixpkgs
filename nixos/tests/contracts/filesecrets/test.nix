{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) getAttrFromPath setAttrByPath;
  inherit (lib) mkOption types;
in
{
  name,
  providerRoot,
  extraModules ? [ ],
}:
{
  name = "contracts_filesecrets_${name}";

  nodes.machine =
    { config, ... }:
    {
      imports = extraModules;

      options.test = {
        owner = mkOption {
          type = types.str;
          default = "root";
        };

        group = mkOption {
          type = types.str;
          default = "root";
        };

        mode = mkOption {
          type = types.str;
          default = "0400";
        };

        content = mkOption {
          type = types.str;
          default = "a super secret secret!";
        };
      };

      config = lib.mkMerge [
        (setAttrByPath providerRoot {
          input = {
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
      inherit (getAttrFromPath providerRoot nodes.machine) output;
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
}
