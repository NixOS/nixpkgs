{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "mazette";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freedomofpress";
    repo = "mazette";
    tag = "0.2.0";
    hash = "sha256-m0D6VP98uIOmG1YTG5S3omcXWVO3nOdFetasf6SZ+RQ=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.colorama
    python3Packages.platformdirs
    python3Packages.requests
    python3Packages.semver
    python3Packages.toml
  ];

  meta = {
    description = "Manage assets from GitHub releases";
    homepage = "https://github.com/freedomofpress/mazette";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.keysmashes ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "mazette";
  };
}
