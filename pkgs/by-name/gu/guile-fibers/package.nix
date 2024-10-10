{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  guile,
  libevent,
  pkg-config,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-fibers";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wingo";
    repo = "fibers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jJKA5JEHsmqQ/IKb1aNmOtoVaGKNjcgTKyo5VCiJbXM=";
  };

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

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/wingo/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ vyp ];
    inherit (guile.meta) platforms;
  };
})
