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
      name = "serenity";
      owner = "SerenityOS";
      repo = "serenity";
      rev = "35fd7a6770144259a05d41dfffbc8092495c4bf2";
      hash = "sha256-i48egESwQKhcEAObSg2zqubgNdkXE5FlNa+Jukvg2X8=";
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
    ./patches/pixart2svg-rgba-no-style-imageio-warning-fix.patch
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p svgfiles

    i=0

    for file in serenity/Base/res/emoji/*.png; do

      i=$((i+1))
      echo "[$i/$(ls -1 serenity/Base/res/emoji/*.png | wc -l)] Converting $(basename -- $file)"
      python3 pixart2svg/pixart2svg.py "$file" svgfiles/"$(basename -- ''${file%.*}).svg"

    done

    nanoemoji --family "SerenityOS Emoji" --output_file "SerenityOS-Emoji.ttf" --color_format glyf_colr_1 svgfiles/*.svg

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
