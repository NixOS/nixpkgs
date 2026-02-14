{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
}:

stdenv.mkDerivation {
  pname = "sidfactory2";
  version = "20231002";

  src = fetchFromGitHub {
    owner = "Chordian";
    repo = "sidfactory2";
    rev = "e06dce7a113d52a5dcc2469ed1dcc4144cba6045";
    hash = "sha256-Kg+LbWXcUIW/WUnRwCQSEhEs78u1aMpVsR8b2Y0as4E=";
  };

  buildInputs = [
    SDL2
  ];

  buildPhase = ''
    make dist
  '';

  installPhase = ''

    ARTIFACT_DIR=$(find artifacts -type d -name "SIDFactoryII_*" | head -n 1)

    cd "$ARTIFACT_DIR" || {
      echo "Error: Could not find build artifacts directory 'SIDFactoryII_*' inside 'artifacts/'"
      exit 1
    }

    install -D -m 555 SIDFactoryII $out/bin/sidfactory2
    install -d $out/bin/overlay
    find drivers -type f -exec install -m 444 -D {} $out/bin/{} \;

  '';

  meta = with lib; {
    description = "SID Factory II - A cross-platform tracker for Commodore 64 music";
    homepage = "https://blog.chordian.net/sf2/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kmogged ];
    platforms = platforms.linux;
    mainProgram = "sidfactory2";
  };
}
