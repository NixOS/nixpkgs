{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  rustc,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  gettext,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  a52dec,
  fdk_aac,
  ffmpeg,
  x264,
  x265,
  vo-aacenc,
  svt-av1,
  libmpeg2,
}:

stdenv.mkDerivation rec {
  pname = "footage";
  version = "1.3.2";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Footage";
    rev = "refs/tags/v${version}";
    hash = "sha256-VEL96JrJ5eJEoX2miiB4dqGUXizNlYWCUZkkYkh09B8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-RWMNeMrctIlcA4MiRx9t7OfzKeHtw3phrYsYFZH7z4c=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    gtk4 # for gtk-update-icon-cache
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
      a52dec
      fdk_aac
      ffmpeg
      x264
      x265
      vo-aacenc
      svt-av1
      libmpeg2
    ]
    ++ (with gst_all_1; [
      gst-plugins-base
      gst-plugins-good
      gst-plugins-rs
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gstreamer
      gst-editing-services
    ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ gst_all_1.gstreamer ]}"
    )
  '';

  meta = {
    description = "Video editing tool that allows you to trim, flip, rotate, and crop clips";
    homepage = "https://gitlab.com/adhami3310/Footage";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onny ];
  };
}
