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
, libhandy_0
, gtk3
, dbus
, openssl
, sqlite
, gst_all_1
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-podcasts";
  version = "0.4.8";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    sha256 = "0y2332zjq7vf1v38wzwz98fs19vpzy9kl7y0xbdzqr303l59hjb1";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-GInRA/V61r42spb/JYlM8+mATSkmOxdm2zHPRWaKcck=";
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
    glib
    gtk3
    libhandy_0
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
  };
}
