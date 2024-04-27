{ lib, stdenv, fetchFromGitHub, perl, libxcb, libXft }:

stdenv.mkDerivation {
  pname = "lemonbar-xft";
  version = "unstable-2020-09-10";

  src = fetchFromGitHub {
    owner = "drscream";
    repo = "lemonbar-xft";
    rev = "481e12363e2a0fe0ddd2176a8e003392be90ed02";
    sha256 = "sha256-BNYBbUouqqsRQaPkpg+UKg62IV9uI34gKJuiAM94CBU=";
  };

  buildInputs = [ libxcb libXft perl ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with lib; {
    description = "A lightweight xcb based bar with XFT-support";
    mainProgram = "lemonbar";
    homepage = "https://github.com/drscream/lemonbar-xft";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ moni ];
  };
}
