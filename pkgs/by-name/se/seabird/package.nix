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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "getseabird";
    repo = "seabird";
    rev = "v${version}";
    hash = "sha256-wrZLWDTgcUS8snCqc5rInqitAkrsStL8zmc8vjl4ApQ=";
  };

  vendorHash = "sha256-z9l6g5NkAErRQo8oiqwKG9ssm8K2S+eSZBD0w4kO3kc=";

  nativeBuildInputs = [
    copyDesktopItems
    libxml2
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gobject-introspection
    gtk4
    gtksourceview5
    libadwaita
    vte-gtk4
  ];

  ldflags = [ "-s" "-w" ];

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
