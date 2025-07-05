{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  s-tui,
  testers,
  stress,
}:

python3Packages.buildPythonPackage rec {
  pname = "s-tui";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "amanusk";
    repo = "s-tui";
    tag = "v${version}";
    hash = "sha256-VdQSDRDdRO6jHSuscOQZXnVM6nWHaXRfR4sZ3x5lriI=";
  };

  propagatedBuildInputs = [
    python3Packages.urwid
    python3Packages.psutil
    stress
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = s-tui; };
  };

  meta = with lib; {
    homepage = "https://amanusk.github.io/s-tui/";
    description = "Stress-Terminal UI monitoring tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lilacious ];
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/amanusk/s-tui/issues/49
    mainProgram = "s-tui";
  };
}
