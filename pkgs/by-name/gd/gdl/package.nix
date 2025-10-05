{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libxml2,
  gtk3,
  gnome,
  intltool,
}:

stdenv.mkDerivation rec {
  pname = "gdl";
  version = "3.40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gdl/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "NkHU/WadHhgYrv88+f+3iH/Fw2eFC3jCjHdeukq2pVU=";
  };

  env = lib.optionalAttrs stdenv.cc.isGNU {
    # https://gitlab.gnome.org/Archive/gdl/-/issues/9
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [
    libxml2
    gtk3
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gdl";
    };
  };

  meta = with lib; {
    description = "Gnome docking library";
    homepage = "https://developer.gnome.org/gdl/";
    teams = [ teams.gnome ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
