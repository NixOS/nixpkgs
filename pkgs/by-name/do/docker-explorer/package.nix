{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "docker-explorer";
  version = "20241004";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "docker-explorer";
    tag = version;
    hash = "sha256-QTzvq6/1LscY5uYKm2Sq+2uDgM8U7t79wedq5MqRKEU=";
  };

  build-system = [ python3.pkgs.setuptools ];

  dependencies = [ python3.pkgs.requests ];

  meta = {
    description = "Forensicate offline docker acquisitions";
    homepage = "https://github.com/google/docker-explorer";
    changelog = "https://github.com/google/docker-explorer/releases/tag/${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "de.py";
  };
}
