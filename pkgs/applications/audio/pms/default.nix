{ stdenv
, buildGoModule
, fetchFromGitHub
, go
, ncurses
}:

buildGoModule rec {
  pname = "pms";
  version = "0.42";

  src = fetchFromGitHub {
    owner  = "ambientsound";
    repo   = "pms";
    rev    = version;
    sha256 = "1ckfgmq7wk91fzhzimab47lypdba7084ynyqyx9z1jg1zjgs68nn";
  };

#  nativeBuildInputs = [ go ];

  modSha256 = "01xbv4zfhii0g41cy0ycfpkkxw6nnd4ibavic6zqw30j476jnm2x";

  meta = with stdenv.lib; {
    description = "Practical Music Search is an interactive Vim-like console client for the Music Player Daemon";
    homepage = https://ambientsound.github.io/pms/;
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

