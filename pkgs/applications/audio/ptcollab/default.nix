{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.5.0.1";

  src = fetchFromGitHub {
    owner = "yuxshao";
    repo = "ptcollab";
    rev = "v${version}";
    sha256 = "10v310smm0df233wlh1kqv8i36lsg1m36v0flrhs2202k50d69ri";
  };

  patches = [
    # Lifts macOS version restriction
    # Remove when version > 0.5.0.1
    (fetchpatch {
      name = "0001-ptcollab-lift-10.14-deployment-target-limitation.patch";
      url = "https://github.com/yuxshao/ptcollab/commit/a9664b5953e1046e1f7da3b38744f33a7ff0ea24.patch";
      sha256 = "0qgpv5hmb4504kamdgxalrhc4zb9rdxln23s7qwc7ikafg54h1fm";
    })
  ];

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
