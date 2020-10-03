{ stdenv
, rustPlatform
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, gettext
, cargo
, rustc
, python3
, pkgconfig
, glib
, libhandy_0
, gtk3
, dbus
, openssl
, sqlite
, gst_all_1
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  version = "0.4.8";
  pname = "gnome-podcasts";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    sha256 = "0y2332zjq7vf1v38wzwz98fs19vpzy9kl7y0xbdzqr303l59hjb1";
  };

  cargoSha256 = "1jbii9k4bkrivdk1ffr6556q1sgk9j4jbzwnn8vbxmksyl1x328q";

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    cargo
    rustc
    python3
    wrapGAppsHook
    glib
  ];

  buildInputs = [
    glib
    gtk3
    libhandy_0
    dbus
    openssl
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  # use Meson/Ninja phases
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  # tests require network
  doCheck = false;

  postPatch = ''
    chmod +x scripts/compile-gschema.py # patchShebangs requires executable file
    patchShebangs scripts/compile-gschema.py scripts/cargo.sh scripts/test.sh
  '';

  meta = with stdenv.lib; {
    description = "Listen to your favorite podcasts";
    homepage = "https://wiki.gnome.org/Apps/Podcasts";
    license = licenses.gpl3;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
