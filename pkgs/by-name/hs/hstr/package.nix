{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
  ncurses,
  autoreconfHook,
  pkg-config,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hstr";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "dvorka";
    repo = "hstr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kjTFZTvHX6snftKSqx6Kt5TLk+r2nK7ZaxrZoKVdjm0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    readline
    ncurses
    gettext
  ];

  configureFlags = [ "--prefix=$(out)" ];

  meta = {
    homepage = "https://github.com/dvorka/hstr";
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = with lib.platforms; linux ++ darwin;
  };

})
