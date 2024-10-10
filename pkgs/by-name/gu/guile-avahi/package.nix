{
  lib,
  autoreconfHook,
  avahi,
  buildPackages,
  fetchFromSavannah,
  gmp,
  guile,
  pkg-config,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-avahi";
  version = "0.4.1";

  src = fetchFromSavannah {
    repo = "guile-avahi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Yr+OiqaGv6DgsjxSoc4sAjy4OO/D+Q50vdSTPEeIrV8=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  propagatedBuildInputs = [
    avahi
    gmp
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-unused-function";

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://www.nongnu.org/guile-avahi/";
    description = "Bindings to Avahi for GNU Guile";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ foo-dogsquared ];
    inherit (guile.meta) platforms;
  };
})
