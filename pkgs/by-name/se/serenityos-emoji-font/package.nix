{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchzip,
  python3Packages,
  fetchpatch2,
  parallel,
}:
let

  pixart2svg = stdenvNoCC.mkDerivation {
    name = "pixart2svg";
    version = "0-unstable-2021-07-18";

    src = fetchzip {
      name = "pixart2svg";
      url = "https://gist.github.com/m13253/66284bc244deeff0f0f8863c206421c7/archive/f9454958dc0a33cea787cc6fbd7e8e34ba6eb23b.zip";
      hash = "sha256-lNA3qWK/bnUcMM/jrCGEgaX+HAk/DjKJnkE8niYmBDU=";
    };

    patches =
      let
        urlFor =
          name:
          "https://raw.githubusercontent.com/linusg/serenityos-emoji-font/11c84f33777a5d5bbe97ef2ffe8b74af7d72d27f/patches/${name}.patch";
      in
      [
        (fetchpatch2 {
          url = urlFor "0001-pixart2svg-rgba";
          extraPrefix = "./";
          hash = "sha256-/4a6btqp/6yiBnFhr4vI+SWfOopUjzDfOeW1Fs6Z5yU=";
        })
        (fetchpatch2 {
          url = urlFor "0002-pixart2svg-no-style";
          extraPrefix = "./";
          hash = "sha256-FVurs+bEOat74d2egl21JS5ywdkFKKIsqXSFGSJI8MI=";
        })
        (fetchpatch2 {
          url = urlFor "0003-pixart2svg-imageio-deprecation-warning";
          extraPrefix = "./";
          hash = "sha256-Vo3JIcXof+AtuEbsczNS3CUaBUEncCR0pnIuY4uF7R4=";
        })
      ];

    installPhase = ''
      mkdir -p $out
      cp ./pixart2svg.py $out
    '';
  };

in
stdenvNoCC.mkDerivation {
  name = "serenityos-emoji-font";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    name = "serenity";
    owner = "SerenityOS";
    repo = "serenity";
    rev = "35fd7a6770144259a05d41dfffbc8092495c4bf2";
    hash = "sha256-i48egESwQKhcEAObSg2zqubgNdkXE5FlNa+Jukvg2X8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pixart2svg
    parallel
  ]
  ++ (with python3Packages; [
    imageio
    nanoemoji
    numpy
  ]);

  buildPhase = ''
    runHook preBuild

    mkdir -p svgfiles

    total=$(ls -1 Base/res/emoji/*.png | wc -l)

    parallel -j$NIX_BUILD_CORES \
      echo [{#}/$total] Converting {/} \; python3 ${pixart2svg}/pixart2svg.py {} svgfiles/{/.}.svg \
      ::: Base/res/emoji/*.png;

    nanoemoji --family "SerenityOS Emoji" --output_file "SerenityOS-Emoji.ttf" --color_format glyf_colr_1 svgfiles/*.svg

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp build/SerenityOS-Emoji.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "SerenityOS pixel art emojis as a TTF";
    homepage = "https://emoji.serenityos.org/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      voidnoi
    ];
    platforms = lib.platforms.all;
  };
}
