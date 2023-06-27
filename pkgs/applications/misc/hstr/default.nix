{ lib, stdenv, fetchFromGitHub, readline, ncurses
, autoreconfHook, pkg-config, gettext }:

stdenv.mkDerivation rec {
  pname = "hstr";
  version = "3.1";

  src = fetchFromGitHub {
    owner  = "dvorka";
    repo   = "hstr";
    rev    = version;
    hash   = "sha256-OuLy1aiEwUJDGy3+UXYF1Vx1nNXic46WIZEM1xrIPfA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ readline ncurses gettext ];

  configureFlags = [ "--prefix=$(out)" ];

  meta = {
    homepage = "https://github.com/dvorka/hstr";
    description = "Shell history suggest box - easily view, navigate, search and use your command history";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    platforms = with lib.platforms; linux ++ darwin;
  };

}
