{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-07-25";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "f13aa044de9d7b8922a12e895f3ff3f86b60e939";
    sha256 = "sha256-siQoRgbJIVtBXqrxJzdVABnDgdHqW5FLSJpBrL0iVuU=";
  };

  vendorSha256 = "sha256-hgojB1D0/SZWLEzJ48EBoT/InYYmqD/1qoTknfk/aTo=";

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
