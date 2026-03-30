{
  lib,
  nixos,
  expect,
  testers,
}:
let
  node-forbiddenDependencies-fail = nixos (
    { config, ... }:
    {
      system.forbiddenDependenciesRegexes = [ "-dev$" ];
      environment.etc."dev-dependency" = {
        text = "${expect.dev}";
      };
      documentation.enable = false;
      fileSystems."/".device = "ignore-root-device";
      boot.loader.grub.enable = false;

      # Don't do this in an actual config
      system.stateVersion = config.system.nixos.release;
    }
  );
  node-forbiddenDependencies-succeed = nixos (
    { config, ... }:
    {
      system.forbiddenDependenciesRegexes = [ "-dev$" ];
      system.extraDependencies = [ expect.dev ];
      documentation.enable = false;
      fileSystems."/".device = "ignore-root-device";
      boot.loader.grub.enable = false;

      # Don't do this in an actual config
      system.stateVersion = config.system.nixos.release;
    }
  );
in
lib.recurseIntoAttrs {
  test-forbiddenDependencies-fail = testers.testBuildFailure node-forbiddenDependencies-fail.config.system.build.toplevel;
  test-forbiddenDependencies-succeed =
    node-forbiddenDependencies-succeed.config.system.build.toplevel;
}
