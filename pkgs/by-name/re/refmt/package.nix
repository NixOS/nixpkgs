{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "refmt";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "rjeczalik";
    repo = "refmt";
    rev = "v${version}";
    sha256 = "sha256-HiAWSR2S+3OcIgwdQ0ltW37lcG+OHkDRDUF07rfNcJY=";
  };

  vendorHash = "sha256-MiYUDEF9W0VAiOX6uE8doXtGAekIrA1cfA8A2a7xd2I=";

  meta = with lib; {
    description = "Reformat HCL <-> JSON <-> YAML";
    mainProgram = "refmt";
    homepage = "https://github.com/rjeczalik/refmt";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [ deemp ];
  };
}
