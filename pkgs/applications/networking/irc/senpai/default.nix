{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-11-04";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "3be87831281af1c91a6e406986f317936a0b98bc";
    sha256 = "sha256-v8r2q2H4I9FnsIOGv1zkC4xJ5E9cQavfILZ6mnbFbr8=";
  };

  vendorSha256 = "sha256-FBpk9TpAD5i3+brsVNWHNHJtZsHmShmWlldQrMs/VGU=";

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
