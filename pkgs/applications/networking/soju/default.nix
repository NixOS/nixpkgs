{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "soju";
  version = "0.2.2";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "soju";
    rev = "v${version}";
    sha256 = "sha256-ssq4fED7YIJkSHhxybBIqOr5qVEHGordBxuJOmilSOY=";
  };

  vendorSha256 = "sha256-60b0jhyXQg9RG0mkvUOmJOEGv96FZq/Iwv1S9c6C35c=";

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
