{ lib
, nixos
, expect
, testers
, runCommand
}:
let
  node-forbiddenDependencies-fail = nixos ({ ... }: {
    system.forbiddenDependenciesRegex = "-dev$";
    environment.etc."dev-dependency" = {
      text = "${expect.dev}";
    };
    documentation.enable = false;
    fileSystems."/".device = "ignore-root-device";
    boot.loader.grub.enable = false;
  });
  node-forbiddenDependencies-succeed = nixos ({ ... }: {
    system.forbiddenDependenciesRegex = "-dev$";
    system.extraDependencies = [ expect.dev ];
    documentation.enable = false;
    fileSystems."/".device = "ignore-root-device";
    boot.loader.grub.enable = false;
  });
in
lib.recurseIntoAttrs rec {
  test-forbiddenDependencies-fail = testers.testBuildFailure node-forbiddenDependencies-fail.config.system.build.toplevel;
  # The build log for the system with the forbidden dependency should
  # show the path to the dependency, via the etc derivation.
  test-forbiddenDependencies-fail-message = runCommand "check-failure-message" {} ''
    grep ${node-forbiddenDependencies-fail.config.system.build.etc} ${test-forbiddenDependencies-fail}/testBuildFailure.log
    grep ${expect.dev} ${test-forbiddenDependencies-fail}/testBuildFailure.log
    touch $out
  '';
  test-forbiddenDependencies-succeed = node-forbiddenDependencies-succeed.config.system.build.toplevel;
}
