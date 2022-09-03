{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, gnome
, pkg-config
, meson
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, blueprint-compiler
, ninja
, python3
, gtk3-x11
, glib
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
    # The metainfo.xml file has a URL to a screenshot of the application,
    # unaccessible in the build's sandbox. We don't need the screenshot, so
    # it's best to remove it.
    ./remove-screenshot-metainfo.diff
  ];

  postPatch = ''
    patchShebangs \
      build-aux/meson/postinstall.py \
      build-aux/cargo.sh \
      build-aux/dist-vendor.sh
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    blueprint-compiler
    ninja
    # For post-install.py
    python3
    gtk3-x11 # For gtk-update-icon-cache
    glib # For glib-compile-schemas
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gobject-introspection
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  doCheck = true;

  passthru.updateScript = gnome.updateScript {
    packageName = pname;
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    description = "Trim videos quickly";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
