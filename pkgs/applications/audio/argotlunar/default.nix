 { stdenv
 , lib
 , fetchFromGitHub
 , alsa-lib
 , freetype
 , curl
 , pkg-config
 , cmake
 , xorg
 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "argotlunar";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "mourednik";
    repo = "argotlunar";
    rev = "1527d5dd753a7af32600ac677337469bbf1d40cd";
    hash = "sha256-U20ZUFrck/Y3GwqEnPZewnUN1YIFucgNsJJTMtWY3wE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    curl
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libxshmfence
    xorg.libXext
    xorg.libXcursor
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$TMPDIR
    cmake . -B cmake-build

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cmake --build cmake-build --target all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    cd cmake-build/Argotlunar_artefacts
    cp -r VST3/Argotlunar.vst3 $out/lib/vst3/

    runHook postInstall
  '';

  meta = {
    homepage = "https://mourednik.github.io/argotlunar/";
    description = "A tool for creating surreal transformations of audio streams";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ betodealmeida ];
    platforms = lib.platforms.linux;
  };
})
