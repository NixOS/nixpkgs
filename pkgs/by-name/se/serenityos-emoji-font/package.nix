{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  pkgs,
}:
stdenvNoCC.mkDerivation {
  name = "serenityos-emoji-font";
  version = "1.0";

  srcs = [
    (fetchFromGitHub {
      name = "serenityos-emoji-font";
      owner = "linusg";
      repo = "serenityos-emoji-font";
      rev = "11c84f3";
      hash = "sha256-irTxRIWYROFkJuDkRrRrwf8lzf6ecmhppinWbQ2JMyI=";
    })
    (fetchzip {
      name = "emojis";
      url = "https://emoji.serenityos.net/SerenityOS-RGI-emoji.zip";
      hash = "sha256-qLptFI5FNN9NQpvXsAlkyMnME7fQrtMFbz9TnMiy80I=";
      stripRoot = false;
    })
    (fetchzip {
      name = "pixart2svg";
      url = "https://gist.github.com/m13253/66284bc244deeff0f0f8863c206421c7/archive/f9454958dc0a33cea787cc6fbd7e8e34ba6eb23b.zip";
      hash = "sha256-lNA3qWK/bnUcMM/jrCGEgaX+HAk/DjKJnkE8niYmBDU=";
    })
  ];
  sourceRoot = ".";

  buildInputs = with pkgs.python313Packages; [
    imageio
    nanoemoji
    numpy
  ];

  patches = [
    ./patches/build-paths-fix.patch
    ./patches/pixart2svg-rgba-no-style-imageio-warning-fix.patch
  ];

  buildPhase = ''
    runHook preBuild

    python serenityos-emoji-font/main.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp build/SerenityOS-Emoji.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "😃 The SerenityOS pixel art emojis as a TTF";
    homepage = "https://emoji.serenityos.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      voidnoi
    ];
  };
}
