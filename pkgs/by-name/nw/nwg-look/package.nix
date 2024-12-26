{ lib
, fetchFromGitHub
, wrapGAppsHook3
, buildGoModule
, glib
, pkg-config
, cairo
, gtk3
, xcur2png
, libX11
, zlib
}:

buildGoModule rec {
  pname = "nwg-look";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-look";
    rev = "v${version}";
    hash = "sha256-qUNTJkNHWoJisLH0SU23UQuamEL27MMRnxw0kBxzWLk=";
  };

  vendorHash = "sha256-qHWy9OCxENrrWk00YoRveSjqYWIy/fe4Fyc8tc4n34E=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    cairo
    xcur2png
    libX11.dev
    zlib
    gtk3
  ];

  env.CGO_ENABLED = 1;

  postInstall = ''
    mkdir -p $out/share
    mkdir -p $out/share/nwg-look/langs
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/icons
    cp stuff/main.glade $out/share/nwg-look/
    cp langs/* $out/share/nwg-look/langs
    cp stuff/nwg-look.desktop $out/share/applications
    cp stuff/nwg-look.svg $out/share/pixmaps
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${glib.bin}/bin"
      --prefix PATH : "${xcur2png}/bin"
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/nwg-look";
    description = "Nwg-look is a GTK3 settings editor, designed to work properly in wlroots-based Wayland environment";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ max-amb ];
    mainProgram = "nwg-look";
  };
}
