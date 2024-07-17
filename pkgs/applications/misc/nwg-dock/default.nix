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
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/iUtVym+fNnbBeLlrYIiO5tV9eeAVBh6Nw+d3GCJ/F8=";
  };

  vendorHash = "sha256-GW+shKOCwU8yprEfBeAPx1RDgjA7cZZzXDG112bdZ6k=";

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
