{ lib
, nixos
, expect
, testers
}:
let
  node-forbiddenDependencies-fail = nixos ({ ... }: {
    system.forbiddenDependenciesRegexes = ["-dev$"];
    environment.etc."dev-dependency" = {
      text = "${expect.dev}";
    };
    documentation.enable = false;
    fileSystems."/".device = "ignore-root-device";
    boot.loader.grub.enable = false;
  });
  node-forbiddenDependencies-succeed = nixos ({ ... }: {
    system.forbiddenDependenciesRegexes = ["-dev$"];
    system.extraDependencies = [ expect.dev ];
    documentation.enable = false;
    fileSystems."/".device = "ignore-root-device";
    boot.loader.grub.enable = false;
  });
in
lib.recurseIntoAttrs {
  test-forbiddenDependencies-fail = testers.testBuildFailure node-forbiddenDependencies-fail.config.system.build.toplevel;
  test-forbiddenDependencies-succeed = node-forbiddenDependencies-succeed.config.system.build.toplevel;
}
