{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "factorio-mod-manager";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "henkkuli";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/zdoiX1V5BBjkaGpKPVIQS90JweydmEHslClTzCYo3Q=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [
    python3Packages.requests
  ];

  meta = with lib; {
    homepage = "https://github.com/henkkuli/Factorio-Mod-Manager";
    description = "A command-line tool for managing Factorio mods with dependency resolution and version locking, intended especially for server admins";
    license = licenses.gpl3;
    maintainers = [
      maintainers.henkkuli
    ];
    mainProgram = "fmm";
  };
}
