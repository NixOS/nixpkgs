{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  libX11,
  libXft,
  libXinerama,
}:

stdenv.mkDerivation rec {
  pname = "xmenu";
  version = "4.5.5";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xmenu";
    rev = "v${version}";
    sha256 = "sha256-Gg4hSBBVBOB/wlY44C5bJOuOnLoA/tPvcNZamXae/WE=";
  };

  buildInputs = [
    imlib2
    libX11
    libXft
    libXinerama
  ];

  postPatch = "sed -i \"s:/usr/local:$out:\" config.mk";

  meta = with lib; {
    description = "A menu utility for X";
    homepage = "https://github.com/phillbush/xmenu";
    license = licenses.mit;
    maintainers = with maintainers; [ neonfuz ];
    platforms = platforms.all;
    mainProgram = "xmenu";
  };
}
