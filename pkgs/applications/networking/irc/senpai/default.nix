{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-11-15";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "cb0ba0669522ecf8ab0b0c3ccd0f14827eb65832";
    sha256 = "sha256-Ny7TAKdh7RFGlrMRVIyCFFLqOanNWK+qGBbh+dVngMs=";
  };

  vendorSha256 = "sha256-dCADJ+k2vWLpgN251/gEyAg6WhPGK2DEWRaAHSHp1aM=";

  subPackages = [
    "cmd/senpai"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/senpai.1.scd > doc/senpai.1
    scdoc < doc/senpai.5.scd > doc/senpai.5
    installManPage doc/senpai.*
  '';

  meta = with lib; {
    description = "Your everyday IRC student";
    homepage = "https://ellidri.org/senpai";
    license = licenses.isc;
    maintainers = with maintainers; [ malvo ];
  };
}
