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
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "amanusk";
    repo = "s-tui";
    tag = "v${version}";
    hash = "sha256-PDDT37W0x7VJ6OnkbwvPXttphD+vHDul0zmA3VY/Sao=";
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

  meta = {
    homepage = "https://amanusk.github.io/s-tui/";
    description = "Stress-Terminal UI monitoring tool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lilacious ];
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/amanusk/s-tui/issues/49
    mainProgram = "s-tui";
  };
}
