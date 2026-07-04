{
  pkgs,
  evalSystem,
  runTest,
  callTest,
}:

let
  sharedDir = "/tmp/modular-service-compliance";
in
let
  suite = pkgs.testers.modularServiceCompliance {
    inherit sharedDir;
    namePrefix = "system-services-compliance";
    evalConfig =
      { services }:
      let
        machine = evalSystem (
          { ... }:
          {
            system.services = services;
            system.stateVersion = "25.05";
            fileSystems."/" = {
              device = "/test/dummy";
              fsType = "auto";
            };
            boot.loader.grub.enable = false;
          }
        );
      in
      {
        config = machine.config.system.services;
        checkDrv = machine.config.system.build.toplevel;
      };
    mkTest =
      {
        name,
        services,
        testExe,
      }:
      runTest {
        _class = "nixosTest";
        inherit name;
        nodes.machine.system.services = services;
        testScript = ''
          machine.wait_for_unit("multi-user.target")
          machine.succeed("${testExe}")
        '';
        meta.maintainers = with pkgs.lib.maintainers; [ roberth ];
      };
  };
in

# Please the callTest pattern.
#
# runTest results already go through findTests/callTest.
# For plain derivations like `eval`, we apply callTest directly.
pkgs.lib.mapAttrs (
  _: v:
  if v ? test then
    v
  else
    callTest {
      test = v;
      driver = v;
    }
) suite
