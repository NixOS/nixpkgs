{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  gupnp_1_6,
  libsoup_3,
  gssdp_1_6,
  pkg-config,
  gtk3,
  gettext,
  gupnp-av,
  gtksourceview4,
  gnome,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
  version = "0.12.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "U8+TEj85fo+PC46eQ2TIanUCpTNPTAvi4FSoJEeL1bo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    gupnp_1_6
    libsoup_3
    gssdp_1_6
    gtk3
    gupnp-av
    gtksourceview4
  ];

  # new libxml2 version
  # TODO: can be dropped on next update
  NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-declarations" ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Set of utilities and demos to work with UPnP";
    homepage = "https://gitlab.gnome.org/GNOME/gupnp-tools";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
