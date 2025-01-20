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
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "spritely";
    repo = "guile-hoot";
    rev = "v${version}";
    hash = "sha256-n8u0xK2qDLGySxiYWH882/tkL8ggu3hivHn3qdDO9eI=";
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
