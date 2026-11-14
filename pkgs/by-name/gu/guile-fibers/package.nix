{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  guile,
  libevent,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-fibers";
  version = "2.0.0";

  src = fetchFromCodeberg {
    owner = "guile";
    repo = "fibers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8SjXDkJ6iokC4xld1bUhCx2OIlVZopWy+xlpUvh4HbU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo # for makeinfo
  ];

  buildInputs = [
    guile
    libevent
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  guileImportsCheck = [ "fibers" ];

  meta = {
    homepage = "https://codeberg.org/guile/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
})
