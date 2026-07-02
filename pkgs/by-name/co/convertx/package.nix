{
  stdenv,
  lib,
  fetchFromGitHub,

  # Build deps
  bun,
  tailwindcss_4,
  typescript,
  makeBinaryWrapper,

  # Runtime deps
  assimp,
  calibre,
  dasel,
  ffmpeg-headless,
  graphicsmagick,
  imagemagick,
  inkscape,
  libheif,
  libjxl,
  libreoffice,
  libva,
  pandoc,
  perl5Packages,
  potrace,
  python3,
  resvg,
  texliveBasic,
  vips,
  vtracer,
}:
let
  pin = lib.importJSON ./pin.json;
  inherit (pin) version;

  pname = "convertx";

  src = fetchFromGitHub {
    owner = "C4illin";
    repo = "ConvertX";
    tag = "v${version}";
    hash = pin.srcHash;
  };

  node_modules = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-node_modules";
    inherit version src;

    dontConfigure = true;

    nativeBuildInputs = [
      bun
    ];

    buildPhase = ''
      runHook preBuild

      bun install --frozen-lockfile --no-progress

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/lib/node_modules

      rm -rf ./node_modules/.cache
      rm -rf node_modules/.bin
      cp -R ./node_modules $out/lib
      cp package.json $out/lib
    '';

    outputHash = pin."${stdenv.system}";
    outputHashMode = "recursive";
  });
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    tailwindcss_4
    typescript
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ln -s ${node_modules}/lib/node_modules ./node_modules
    tailwindcss -i ./src/main.css -o ./public/generated.css
    tsc

    substituteInPlace ./dist/src/index.js \
      --replace-fail "assets: \"public\"" "assets: \"$out/share/convertx/dist/public\""

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/convertx
    cp -R ./dist $out/share/convertx
    cp -R ./public $out/share/convertx/dist
    ln -s ${node_modules}/lib/node_modules $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/convertx \
      --add-flags "run --prefer-offline --no-install $out/share/convertx/dist/src/index.js" \
      --set NODE_ENV production \
      --suffix PATH : ${
        lib.makeBinPath [
          assimp
          calibre
          dasel
          ffmpeg-headless
          graphicsmagick
          imagemagick
          inkscape
          libheif
          libjxl
          libreoffice
          libva
          pandoc
          perl5Packages.EmailOutlookMessage
          potrace
          (python3.withPackages (ps: [ ps.markitdown ]))
          resvg
          (texliveBasic.withPackages (ps: [
            ps.dvisvgm
            ps.latex
            ps.latexmk
            ps.unicode-math
            ps.xcolor
            ps.xetex
          ]))
          vips
          vtracer
        ]
      }
  '';

  meta = {
    description = "Self-hosted online file converter";
    homepage = "https://github.com/C4illin/ConvertX/tree/main";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/C4illin/ConvertX/blob/main/CHANGELOG.md";
    mainProgram = "convertx";
    maintainers = with lib.maintainers; [
      EpicEric
    ];
  };
}
