{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "unstable-2022-10-19";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "b3377c58ffb0bc07d222258ea578bdab723b2ec8";
    sha256 = "sha256-QPqnfGdQJh+XDXTcOCwx5KK85vEQuAv386a+qk68zDU=";
  };

  vendorSha256 = "sha256-+cdGRk/96Xu4IgtmZ8GbqWiKAxxwpAnuAkAnKX0CbmU=";

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
