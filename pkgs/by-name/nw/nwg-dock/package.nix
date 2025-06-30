{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  gtk-layer-shell,
}:

buildGoModule rec {
  pname = "nwg-dock";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-dock";
    rev = "v${version}";
    sha256 = "sha256-Ymk4lpX8RAxWot7U+cFtu1eJd6VHP+JS1I2vF0V1T70=";
  };

  vendorHash = "sha256-iR+ytThRwmCvFEMcpSELPRwiramN5jPXAjaJtda4pOw=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  meta = with lib; {
    description = "GTK3-based dock for sway";
    homepage = "https://github.com/nwg-piotr/nwg-dock";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "nwg-dock";
  };
}
