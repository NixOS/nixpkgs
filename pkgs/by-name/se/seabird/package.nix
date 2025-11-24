{
  lib,
  buildGoModule,
  copyDesktopItems,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  gtksourceview5,
  libadwaita,
  libxml2,
  vte-gtk4,
}:

buildGoModule rec {
  pname = "seabird";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "getseabird";
    repo = "seabird";
    rev = "v${version}";
    hash = "sha256-z+XEOqr7JX376AyGr0zx3AV3P+YqFbyspXMoxidCWY0=";
  };

  vendorHash = "sha256-hPvMSAHWtcJULE9t8TKx8r0OpI9V287UPVACeORqOHA=";

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

  ldflags = [
    "-s"
    "-w"
  ];

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
