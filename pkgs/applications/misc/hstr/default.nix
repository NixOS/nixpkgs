{ lib, stdenv, fetchFromGitHub, readline, ncurses
, autoreconfHook, pkg-config, gettext }:

stdenv.mkDerivation rec {
  pname = "hstr";
  version = "2.6";

  src = fetchFromGitHub {
    owner  = "dvorka";
    repo   = "hstr";
    rev    = version;
    sha256 = "sha256-yfaDISnTDb20DgMOvh6jJYisV6eL/Mp5jafnWEnFG8c=";
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
