{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "guile-hoot";
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "spritely";
    repo = "guile-hoot";
    rev = "v${version}";
    hash = "sha256-xPU4uLyh3gd2ubyGednCqB3uzKrabhXQhs6vBc8z0ps=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
  ];
  strictDeps = true;

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  configureFlags = [
    "--with-guile-site-dir=$(out)/${guile.siteDir}"
    "--with-guile-site-ccache-dir=$(out)/${guile.siteCcacheDir}"
  ];

  meta = {
    description = "Scheme to WebAssembly compiler backend for GNU Guile and a general purpose WASM toolchain";
    homepage = "https://gitlab.com/spritely/guile-hoot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
    platforms = lib.platforms.unix;
  };
}
