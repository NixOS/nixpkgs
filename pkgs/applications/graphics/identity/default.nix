{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, nix-update-script

, appstream-glib
, blueprint-compiler
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustc
, wrapGAppsHook4

, gst_all_1
, gtk4
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "identity";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "identity";
    rev = "v${version}";
    hash = "sha256-ZBK2Vc2wnohABnWXRtmRdAAOnkTIHt4RriZitu8BW1A=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-5NUnrBHj3INhh9zbdwPink47cP6uJiRyzzdj+yiSVD8=";
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk4
    libadwaita
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A program for comparing multiple versions of an image or video";
    homepage = "https://gitlab.gnome.org/YaLTeR/identity";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ paveloom ];
  };
}
