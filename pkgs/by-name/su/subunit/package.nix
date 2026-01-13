{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  check,
  cppunit,
  perl,
  python3Packages,
}:

# NOTE: for the subunit python library see pkgs/top-level/python-packages.nix

stdenv.mkDerivation (finalAttrs: {
  pname = "subunit";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "testing-cabal";
    repo = "subunit";
    tag = finalAttrs.version;
    hash = "sha256-yM5mlYV7KyPRzPhnbDYBFLn4uiwxFFEotX2r6KcKAwA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
    python3Packages.wrapPython
    python3Packages.testscenarios
  ];
  buildInputs = [
    check
    cppunit
  ];

  propagatedBuildInputs = with python3Packages; [
    testtools
    testscenarios
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script;

  meta = {
    description = "Streaming protocol for test results";
    homepage = "https://github.com/testing-cabal/subunit";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ maevii ];
  };
})
