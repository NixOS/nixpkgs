{ lib
, stdenv
, fetchFromGitHub
, libjpeg
, libpng
, ncurses
, autoreconfHook
, autoconf-archive
, pkg-config
, bash-completion
}:

stdenv.mkDerivation rec {
  version = "1.2.0";
  pname = "jp2a";

  src = fetchFromGitHub {
    owner = "Talinx";
    repo = "jp2a";
    rev = "v${version}";
    sha256 = "sha256-TyXEaHemKfCMyGwK6P2vVL9gPWRLbkaNP0g+/UYGSVc=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    bash-completion
  ];
  buildInputs = [ libjpeg libpng ncurses ];

  installFlags = [ "bashcompdir=\${out}/share/bash-completion/completions" ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://csl.name/jp2a/";
    description = "Small utility that converts JPG images to ASCII";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.FlorianFranzen ];
    platforms = platforms.unix;
    mainProgram = "jp2a";
  };
}
