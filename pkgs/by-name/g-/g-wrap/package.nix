{
  fetchurl,
  lib,
  stdenv,
  guile_2_2,
  guile-lib,
  libffi,
  pkg-config,
  glib,
}:

stdenv.mkDerivation rec {
  pname = "g-wrap";
  version = "1.9.15";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ak0bha37dfpj9kmyw1r8fj8nva639aw5xr66wr5gd3l1rqf5xhg";
  };

  nativeBuildInputs = [ pkg-config ];

  # Note: Glib support is optional, but it's quite useful (e.g., it's used by
  # Guile-GNOME).
  buildInputs = [
    guile_2_2
    glib
    guile-lib
  ];

  propagatedBuildInputs = [ libffi ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  doCheck = true;

  meta = {
    description = "Wrapper generator for Guile";
    mainProgram = "g-wrap-config";
    longDescription = ''
      G-Wrap is a tool (and Guile library) for generating function wrappers for
      inter-language calls.  It currently only supports generating Guile
      wrappers for C functions.
    '';
    homepage = "https://www.nongnu.org/g-wrap/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
