{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  hatchling,
  hatch-vcs,
  protobuf,
}:

buildPythonPackage rec {
  pname = "ghome-foyer-api";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "ghome-foyer-api";
    tag = "v${version}";
    hash = "sha256-sup+j9GFGTR+HimpkpvvAqtgYWtJt2qCPZzLvMG8hzI=";
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  meta = {
    description = "Generated Python protobuf stubs for Google Home internal API";
    homepage = "https://github.com/KapJI/ghome-foyer-api";
    changelog = "https://github.com/KapJI/ghome-foyer-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hensoko
    ];
  };
}
