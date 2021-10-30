{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "soju";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
    sha256 = "sha256-dauhGfwSjjRt1vl2+OPhtcme/QaRNTs43heQVnI7oRU=";
  };

  vendorSha256 = "sha256-0JLbqqybLZ/cYyHAyNR4liAVJI2oIsHELJLWlQy0qjE=";

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
