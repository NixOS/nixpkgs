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
  version = "0.6.1.1";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "sha256-ydn3qKOK0GwA/mBPbGwSIac09b9cz6YOFbuDFFV8jJs=";
  };

  nativeBuildInputs = [ qmake pkg-config ];

  buildInputs = [ qtbase qtmultimedia libvorbis rtmidi ];

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
  };
}
