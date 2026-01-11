{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  check,
  cppunit,
  perl,
  python3Packages,
}:

# NOTE: for the subunit python library see pkgs/top-level/python-packages.nix

stdenv.mkDerivation (finalAttrs: {
  pname = "subunit";
  version = "1.4.2";

  src = fetchurl {
    url = "https://launchpad.net/subunit/trunk/${finalAttrs.version}/+download/subunit-${finalAttrs.version}.tar.gz";
    hash = "sha256-hlOOv6kIC97w7ICVsuXeWrsUbVu3tCSzEVKUHXYG2dI=";
  };

  nativeBuildInputs = [
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

  postFixup = "wrapPythonPrograms";

  meta = {
    description = "Streaming protocol for test results";
    mainProgram = "subunit-diff";
    homepage = "https://launchpad.net/subunit";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ azey7f ];
  };
})
