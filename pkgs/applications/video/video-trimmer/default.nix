{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, rustPlatform
, gnome
, pkg-config
, meson
, wrapGAppsHook4
, desktop-file-utils
, blueprint-compiler
, ninja
, gobject-introspection
, gtk4
, libadwaita
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "video-trimmer";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = "video-trimmer";
    rev = "v${version}";
    sha256 = "sha256-D7wjJkdqqjjwwYEUZnNr7hFQK59wfTnaCLXCy+SK8Jo=";
  };
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-cB5dVrEbISvHrOb87uVZSkT694VKtPtyk+c1tYNCTp0=";
  };

  patches = [
    # https://gitlab.gnome.org/YaLTeR/video-trimmer/-/merge_requests/12
    (fetchpatch {
      url = "https://gitlab.gnome.org/YaLTeR/video-trimmer/-/commit/2faf4bb13d44463ea940c39ece9187f76627dbe9.diff";
      sha256 = "sha256-BPjwfFCDIqnS1rAlIinQ982VKdAYLyzDAPLCmPDvdp4=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    wrapGAppsHook4
    gobject-introspection
    desktop-file-utils
    blueprint-compiler
    ninja
    # Present here in addition to buildInputs, because meson runs
    # `gtk4-update-icon-cache` during installPhase, thanks to:
    # https://gitlab.gnome.org/YaLTeR/video-trimmer/-/merge_requests/12
    gtk4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    description = "Trim videos quickly";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
