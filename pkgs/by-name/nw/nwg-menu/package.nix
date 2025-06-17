{
  lib,
  fetchFromGitHub,
  buildGoModule,
  pkg-config,
  wrapGAppsHook3,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  pango,
  gdk-pixbuf,
  atk,
}:

buildGoModule rec {
  pname = "nwg-menu";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-menu";
    rev = "v${version}";
    sha256 = "sha256-3fN89HPwobMiijlvGJ80HexCBdsPLsEvAz9VH8dO4qc=";
  };

  vendorHash = "sha256-5gazNUZdPZh21lcnVFKPSDc/JLi8d6tqfP4NKMzPa8U=";

  doCheck = false;

  buildInputs = [
    atk
    gtk3
    gdk-pixbuf
    gtk-layer-shell
    pango
  ];
  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];

  prePatch = ''
    for file in main.go tools.go; do
      substituteInPlace $file --replace '/usr/share/nwg-menu' $out/share
    done
  '';

  postInstall = ''
    mkdir -p $out/share/
    cp menu-start.css $out/share/
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
  '';

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/nwg-menu";
    description = "MenuStart plugin for nwg-panel";
    mainProgram = "nwg-menu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
