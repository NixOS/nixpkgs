{
  lib,
  fetchurl,
  glib,
  guile,
  guile-lib,
  libffi,
  pkg-config,
  stdenv,
  # Boolean flags
  glibSupport ? lib.meta.availableOn stdenv.hostPlatform glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "g-wrap";
  version = "1.9.15";

  src = fetchurl {
    url = "mirror://savannah/g-wrap/g-wrap-${finalAttrs.version}.tar.gz";
    hash = "sha256-D/bicA50tFcyNyb3wlUaRm2LpEM5cF9nkte1MxRcYCo=";
  };

  nativeBuildInputs =
    [
      guile
      pkg-config
    ];

  buildInputs =
    [
      guile
      guile-lib
    ]
    # Note: Glib support is optional, but it's quite useful (e.g., it's used by
    # Guile-GNOME).
    ++ lib.optionals glibSupport [ glib ];

  propagatedBuildInputs = [ libffi ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  doCheck = true;

  strictDeps = true;

  meta = {
    homepage = "https://www.nongnu.org/g-wrap/";
    description = "Wrapper generator for Guile";
    longDescription = ''
      G-Wrap is a tool (and Guile library) for generating function wrappers for
      inter-language calls.  It currently only supports generating Guile
      wrappers for C functions.
    '';
    license = lib.licenses.lgpl2Plus;
    mainProgram = "g-wrap-config";
    maintainers = with lib.maintainers; [ vyp ];
    platforms = lib.platforms.linux;
  };
})
