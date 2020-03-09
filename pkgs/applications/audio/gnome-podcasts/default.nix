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
, gnome3
, glib
, libhandy
, gtk3
, dbus
, openssl
, sqlite
, gst_all_1
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  version = "0.4.7";
  pname = "gnome-podcasts";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    sha256 = "0vy5i77bv8c22ldhrnr4z6kx22zqnb1lg3s7y8673bqjgd7dppi0";
  };

  cargoSha256 = "1dlbdxsf9p2jzrsclm43k95y8m3zcd41qd9ajg1ii3fpnahi58kd";

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    cargo
    rustc
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk3
    libhandy
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
    homepage = https://wiki.gnome.org/Apps/Podcasts;
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
