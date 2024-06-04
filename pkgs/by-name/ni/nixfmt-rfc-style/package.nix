{
  haskell,
  haskellPackages,
  lib,
  runCommand,
  nixfmt-rfc-style,
  fetchpatch,
}:
let
  inherit (haskell.lib.compose) overrideCabal justStaticExecutables;

  overrides = {
    version = "unstable-${lib.fileContents ./date.txt}";

    passthru.updateScript = ./update.sh;

    patches = [
      (fetchpatch {
        url = "https://github.com/serokell/nixfmt/commit/ca9c8975ed671112fdfce94f2e9e2ad3de480c9a.patch";
        hash = "sha256-UOSAYahSKBsqPMVcQJ3H26Eg2xpPAsNOjYMI6g+WTYU=";
      })
    ];

    maintainers = lib.teams.formatter.members;

    # These tests can be run with the following command.
    #
    # $ nix-build -A nixfmt-rfc-style.tests
    passthru.tests =
      runCommand "nixfmt-rfc-style-tests" { nativeBuildInputs = [ nixfmt-rfc-style ]; }
        ''
          nixfmt --version > $out
        '';
  };
  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg [
  (overrideCabal overrides)
  justStaticExecutables
]
