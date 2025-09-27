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
  version = "1.4.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fibers";
    repo = "fibers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y+61jBQHDznWsq3EYnyCkqBo9lM/EPOraUxLd0fu1pc=";
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

  meta = with lib; {
    homepage = "https://codeberg.org/fibers/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = guile.meta.platforms;
  };
})
