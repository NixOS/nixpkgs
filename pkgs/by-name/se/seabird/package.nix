{ lib
, buildGo122Module
, copyDesktopItems
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, gobject-introspection
, gtk4
, gtksourceview5
, libadwaita
, libxml2
, vte-gtk4
}:

buildGo122Module rec {
  pname = "seabird";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "getseabird";
    repo = "seabird";
    rev = "v${version}";
    hash = "sha256-MZEgzTwaBNXLimSj/vXR624DCJ7i2W5lYUdVxqvFii0=";
  };

  vendorHash = "sha256-g7qKI78VeDUu8yafrk2llCIirW/1uxfx6urVLRexsPE=";

  nativeBuildInputs = [
    copyDesktopItems
    gobject-introspection
    libxml2
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    vte-gtk4
  ];

  ldflags = [ "-s" "-w" ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace main.go --replace-fail 'version = "dev"' 'version = "${version}"'
  '';

  preBuild = ''
    go generate internal/icon/icon.go
  '';

  postInstall = ''
    install -Dm644 internal/icon/seabird.svg $out/share/pixmaps/dev.skynomads.Seabird.svg
  '';

  desktopItems = [ "dev.skynomads.Seabird.desktop" ];

  meta = with lib; {
    description = "Native Kubernetes desktop client";
    homepage = "https://getseabird.github.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nicolas-goudry ];
    mainProgram = "seabird";
  };
}
