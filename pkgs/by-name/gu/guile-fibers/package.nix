{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  guile,
  libevent,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-fibers";
  version = "1.4.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "guile";
    repo = "fibers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RiZYHnlvUd1/LAJ7YpOdoMFGpwtGsnp+aDQjxoBPCuA=";
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

  meta = {
    homepage = "https://codeberg.org/guile/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
})
