{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "soju";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
    sha256 = "sha256-j7LwWBBJvNUeg0+P632HaGliVtrrCD0VNxkynaZzidQ=";
  };

  vendorSha256 = "sha256-fDfH2pQ5MtZDjiGx26vS5dBzxejVXPfflLX8N8VcJTA=";

  subPackages = [
    "cmd/soju"
    "cmd/sojuctl"
    "contrib/znc-import.go"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/soju.1.scd > doc/soju.1
    installManPage doc/soju.1
  '';

  meta = with lib; {
    description = "A user-friendly IRC bouncer";
    homepage = "https://soju.im";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ malvo ];
  };
}
