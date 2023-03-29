{ appstream-glib
, blueprint-compiler
, desktop-file-utils
, fetchFromGitLab
, gst_all_1
, gtk4
, lib
, libadwaita
, meson
, ninja
, nix-update-script
, pkg-config
, rustPlatform
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "identity";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "identity";
    rev = "v${version}";
    sha256 = "sha256-ZBK2Vc2wnohABnWXRtmRdAAOnkTIHt4RriZitu8BW1A=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-5NUnrBHj3INhh9zbdwPink47cP6uJiRyzzdj+yiSVD8=";
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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

  meta = {
    description = "A program for comparing multiple versions of an image or video";
    homepage = "https://gitlab.gnome.org/YaLTeR/identity";
    maintainers = [ lib.maintainers.paveloom ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
