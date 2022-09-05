{ stdenv
, fetchFromGitHub
, lib
, pkg-config
, xorg
, cairo
}:

stdenv.mkDerivation rec {
  pname = "activate-linux";
  version = "unstable-2022-05-22";

  src = fetchFromGitHub {
    owner = "MrGlockenspiel";
    repo = pname;
    rev = "18a6dc9771c568c557569ef680386d5d67f25e96";
    sha256 = "wYoCyWZqu/jgqAuNYdNr2bjpz4pFRTnAF7qF4BRs9GE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    xorg.libXinerama
    cairo
  ];


  meta = with lib; {
    description = "The \"Activate Windows\" watermark ported to Linux";
    homepage = "https://github.com/MrGlockenspiel/activate-linux";
    license = licenses.gpl3;
    maintainers = with maintainers; [ alexnortung ];
    platforms = platforms.linux;
  };
}
