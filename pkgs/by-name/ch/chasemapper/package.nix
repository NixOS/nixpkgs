{
  lib,
  fetchFromGitHub,
  python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "chasemapper";
  version = "1.5.3";

  src = fetchFromGithub {
    owner = "projecthorus";
    repo = "chasemapper";
    rev = "v${version}";
    hash = "";
  };

  vendorHash = "";

  meta = {
    description = "Browser-based HAB chase map";
    homepage = "https://github.com/projecthorus/chasemapper";
    license = lib.licenses.gpl3;
    mainProgram = "chasemapper";
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
