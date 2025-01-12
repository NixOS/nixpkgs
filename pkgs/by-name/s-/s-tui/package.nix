{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  nix-update-script,
  s-tui,
  testers,
}:

python3Packages.buildPythonPackage rec {
  pname = "s-tui";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nSdpnM8ubodlPwmvdmNFTn9TsS8i7lWBZ2CifMHDe1c=";
  };

  propagatedBuildInputs = with python3Packages; [
    urwid
    psutil
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = s-tui; };
  };

  meta = with lib; {
    homepage = "https://amanusk.github.io/s-tui/";
    description = "Stress-Terminal UI monitoring tool";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/amanusk/s-tui/issues/49
    mainProgram = "s-tui";
  };
}
