{
  stdenv,
  fetchzip,
  lib,
  autoPatchelfHook,
  makeWrapper,
  libatomic_ops,
  alsa-lib,
  freetype,
  libjack2,
  libGL,
  curl,
  xorg,
  fontconfig,
}:
stdenv.mkDerivation rec {
  pname = "neuralnote";
  version = "1.1.0";

  srcs = [
    (fetchzip {
      name = "app";
      url = "https://github.com/DamRsn/NeuralNote/releases/download/v${version}/NeuralNote_Standalone_Linux.zip";
      sha256 = "sha256-Yi7Fj6kqTRAdwACUPvQwc5mqUMtkejkzGQCSLeWV8uU=";
    })
    (fetchzip {
      name = "vst";
      url = "https://github.com/DamRsn/NeuralNote/releases/download/v${version}/NeuralNote_VST3_Linux.zip";
      sha256 = "sha256-nP7C0t21sQo9aR/7RR03uo60APvZHoGq7yT13jnohEI=";
    })
  ];

  sourceRoot = ".";

  buildInputs = [
    libatomic_ops
    alsa-lib
    freetype
    fontconfig
    libjack2
    libGL
    curl
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXrender
    xorg.libXrandr
    xorg.libXdmcp
    xorg.libXtst
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [makeWrapper autoPatchelfHook];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3/NeuralNote.vst3
    cp -r vst/Contents $out/lib/vst3/NeuralNote.vst3
    
    mkdir -p $out/bin/
    mv ./app/NeuralNote ./app/$pname
    install -m 755 -D ./app/$pname $out/bin/$pname

    runHook postInstall
  '';

  postFixup = let
    libPath = lib.makeLibraryPath [
      libatomic_ops
      alsa-lib
      freetype
      fontconfig
      libjack2
      libGL
      curl
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXinerama
      xorg.libXrender
      xorg.libXrandr
      xorg.libXdmcp
      xorg.libXtst
    ];
  in ''
    wrapProgram $out/bin/$pname \
      --set LD_LIBRARY_PATH ${libPath}
  '';

  meta = with lib; {
    description = "neuralnote";
    homepage = "https://github.com/DamRsn/NeuralNote";
    mainProgram = pname;
    platforms = platforms.x86_64;
  };
}
