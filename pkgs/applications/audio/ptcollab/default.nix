{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, nix-update-script
<<<<<<< HEAD
, libvorbis
, pkg-config
, qmake
, qtbase
, qttools
, qtmultimedia
=======
, qmake
, pkg-config
, qtbase
, qtmultimedia
, libvorbis
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rtmidi
}:

mkDerivation rec {
  pname = "ptcollab";
<<<<<<< HEAD
  version = "0.6.4.7";
=======
  version = "0.6.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-KYNov/HbKM2d8VVO8iyWA3XWFDE9iWeKkRCNC1xlPNw=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
  ];

  buildInputs = [
    libvorbis
    qtbase
    qtmultimedia
    rtmidi
  ];
=======
    sha256 = "sha256-O7CNPMS0eRcqt2xAtyEFyLSV8U2xbxuV1DpBxZAFwQs=";
  };

  nativeBuildInputs = [ qmake pkg-config ];

  buildInputs = [ qtbase qtmultimedia libvorbis rtmidi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Move appbundles to Applications before wrapping happens
    mkdir $out/Applications
    mv $out/{bin,Applications}/ptcollab.app
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Link to now-wrapped binary inside appbundle
    ln -s $out/{Applications/ptcollab.app/Contents/MacOS,bin}/ptcollab
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Experimental pxtone editor where you can collaborate with friends";
    homepage = "https://yuxshao.github.io/ptcollab/";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
