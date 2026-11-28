{
  buildGoModule,
  runCommand,
}:

let
  testPackage = buildGoModule {
    name = "skip-excluded-package";
    src = ./.;
    vendorHash = null;
  };
in

# `excluded` has no Go files for this platform, thus the build skips it.
runCommand "skip-excluded-package-check" { passthru = { inherit testPackage; }; } ''
  [ -x ${testPackage}/bin/skip-excluded-package ]
  touch $out
''
