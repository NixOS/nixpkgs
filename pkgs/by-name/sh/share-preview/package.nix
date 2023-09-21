{ fetchFromGitHub
, rustPlatform
, pkg-config
, lib
, openssl
, glib
, graphene
, pango
, gdk-pixbuf
, gtk4
, libadwaita
, meson
, desktop-file-utils
, ninja
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "share-preview";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "share-preview";
    rev = "refs/tags/${version}";
    hash = "sha256-CsnWQxE2r+uWwuEzHpY/lpWS5i8OXvhRKvy2HzqnQ5U=";
  };

  buildPhase = ''
    runHook preBuild

    meson builddir --prefix=$out
    meson builddir --reconfigure
    cd builddir

    runHook postBuild
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    glib
    gtk4
    desktop-file-utils
    ninja
  ];
  buildInputs = [
    openssl
    glib
    graphene
    pango
    gdk-pixbuf
    gtk4
    libadwaita
    wrapGAppsHook
  ];

  cargoHash = "sha256-H0IDKf5dz+zPnh/zHYP7kCYWHLeP33zHip6K+KCq4is=";

  meta = with lib; {
    description = "Test social media cards locally";
    longDescription = ''
      Preview and debug websites metadata tags for social media share
    '';
    homepage = "https://github.com/rafaelmardojai/share-preview";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ gaykitty ];
    platforms = platforms.all;
  };
}
