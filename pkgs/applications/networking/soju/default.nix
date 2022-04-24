{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "soju";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
    sha256 = "sha256-4ixPEnSa1m52Hu1dzxMG8c0bkqGN04vRlIzvdZ/ES4A=";
  };

  vendorSha256 = "sha256-UVFi/QK2zwzhBkPXEJLYc5WSu3OOvWTVVGkMhrrufyc=";

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
