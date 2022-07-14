{ lib
, stdenv
, fetchFromGitLab
, clang
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

let
  # require 'libadwaita >= 1.2.alpha'
  libadwaita-git = libadwaita.overrideAttrs (oldAttrs: rec {
    version = "1.2.alpha";
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "GNOME";
      repo = "libadwaita";
      rev = version;
      hash = "sha256-JMxUeIOUPp9k5pImQqWLVkQ2GHaKvopvg6ol9pvA+Bk=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "gnome-decoder";
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = version;
    sha256 = "sha256-WJIOaYSesvLmOzF1Q6o6aLr4KJanXVaNa+r+2LlpKHQ=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-RMHVrv/0q42qFUXyd5BSymzx+BxiyqTX0Jzmxnlhyr4=";
  };

  nativeBuildInputs = [
    clang
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
    libadwaita-git
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
    homepage = "https://apps.gnome.org/en/app/com.belmoussaoui.Decoder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
