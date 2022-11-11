{ lib
, clangStdenv
, fetchFromGitLab
, libclang
, rustPlatform
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, zbar
, sqlite
, pipewire
, gstreamer
, gst-plugins-base
, gst-plugins-bad
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

clangStdenv.mkDerivation rec {
  pname = "gnome-decoder";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = version;
    hash = "sha256-WJIOaYSesvLmOzF1Q6o6aLr4KJanXVaNa+r+2LlpKHQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-RMHVrv/0q42qFUXyd5BSymzx+BxiyqTX0Jzmxnlhyr4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
    zbar
    sqlite
    pipewire
    gstreamer
    gst-plugins-base
    gst-plugins-bad
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  meta = with lib; {
    description = "Scan and Generate QR Codes";
    homepage = "https://gitlab.gnome.org/World/decoder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "decoder";
    maintainers = with maintainers; [ zendo ];
  };
}
