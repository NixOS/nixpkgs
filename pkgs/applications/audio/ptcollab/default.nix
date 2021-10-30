{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, nix-update-script
, qmake
, pkg-config
, qtbase
, qtmultimedia
, libvorbis
, rtmidi
}:

mkDerivation rec {
  pname = "ptcollab";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "sha256-sN3O8m+ib6Chb/RXTFbNWW6PnrolCHpmC/avRX93AH4=";
  };

  nativeBuildInputs = [ qmake pkg-config ];

  buildInputs = [ qtbase qtmultimedia libvorbis rtmidi ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Experimental pxtone editor where you can collaborate with friends";
    homepage = "https://yuxshao.github.io/ptcollab/";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    # Requires Qt5.15
    broken = stdenv.hostPlatform.isDarwin;
  };
}
