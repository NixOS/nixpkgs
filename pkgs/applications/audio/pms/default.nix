{ stdenv
, buildGoPackage
, fetchFromGitHub
, go
, ncurses
, ...
}:

buildGoPackage rec {
  name = "pms-${version}";
  version = "0.42";

  src = fetchFromGitHub {
    owner  = "ambientsound";
    repo   = "pms";
    rev    = version;
    sha256 = "1ckfgmq7wk91fzhzimab47lypdba7084ynyqyx9z1jg1zjgs68nn";
  };

  goDeps = ./deps.nix;
  goPackagePath = "github.com/ambientsound/pms";

  meta = with stdenv.lib; {
    description = "Practical Music Search is an interactive Vim-like console client for the Music Player Daemon";
    homepage = https://ambientsound.github.io/pms/;
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

