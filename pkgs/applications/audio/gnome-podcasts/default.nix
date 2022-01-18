{ stdenv
, lib
, rustPlatform
, fetchFromGitLab
, meson
, ninja
, gettext
, python3
, pkg-config
, glib
, libhandy
, gtk3
, appstream-glib
, desktop-file-utils
, dbus
, openssl
, sqlite
, gst_all_1
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-podcasts";
  version = "0.5.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    sha256 = "00vy1qkkpn76jdpybsq9qp8s6fh1ih10j73p2x43sl97m5g8944h";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0y34b5rnr75h7dxbx93mafrmwsh187wq5js7fmkb1m1yyybj1v1x";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    python3
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook
    glib
  ];

  buildInputs = [
    appstream-glib
    desktop-file-utils
    glib
    gtk3
    libhandy
    dbus
    openssl
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
  ];

  # tests require network
  doCheck = false;

  postPatch = ''
    chmod +x scripts/compile-gschema.py # patchShebangs requires executable file
    patchShebangs scripts/compile-gschema.py scripts/cargo.sh scripts/test.sh
  '';

  meta = with lib; {
    description = "Listen to your favorite podcasts";
    homepage = "https://wiki.gnome.org/Apps/Podcasts";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gnome-podcasts.x86_64-darwin
  };
}
