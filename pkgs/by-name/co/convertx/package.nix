{
  stdenv,
  lib,
  fetchFromGitHub,

  # Build deps
  tailwindcss_4,
  typescript,

  # Runtime deps
  bun,
  makeBinaryWrapper,

  # Runtime binary deps
  assimp,
  calibre,
  dasel,
  # dcraw, # Insecure
  ffmpeg-headless,
  ghostscript,
  graphicsmagick,
  imagemagick,
  inkscape,
  libheif,
  libjxl,
  libreoffice,
  libva,
  lmodern,
  mupdf-headless,
  pandoc,
  # perl5Packages, # Not detected
  poppler-utils,
  potrace,
  python3,
  resvg,
  texliveBasic,
  vips,
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

    buildPhase = ''
      ${bun}/bin/bun install --frozen-lockfile --no-progress
    '';

    installPhase = ''
      mkdir -p $out/lib/node_modules

      rm -rf ./node_modules/.cache
      rm -rf node_modules/.bin
      cp -R ./node_modules $out/lib
      cp package.json $out/lib
    '';

    outputHash = pin."${stdenv.system}";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  });
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;

  buildPhase = ''
    ln -s ${node_modules}/lib/node_modules ./node_modules
    ${tailwindcss_4}/bin/tailwindcss -i ./src/main.css -o ./public/generated.css
    ${typescript}/bin/tsc

    substituteInPlace ./dist/src/index.js \
      --replace-fail 'assets: "public"' "assets: \"$out/dist/public\""
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/dist
    cp -R ./dist $out
    cp -R ./public $out/dist
    ln -s ${node_modules}/lib/node_modules $out

    makeBinaryWrapper ${bun}/bin/bun $out/bin/${pname} \
      --set QTWEBENGINE_CHROMIUM_FLAGS "--no-sandbox" \
      --set NODE_ENV production \
      --suffix PATH : ${
        lib.makeBinPath [
          assimp
          calibre
          dasel
          # dcraw
          ffmpeg-headless
          ghostscript
          graphicsmagick
          imagemagick
          inkscape
          libheif
          libjxl
          libreoffice
          libva
          lmodern
          mupdf-headless
          pandoc
          # perl5Packages.EmailOutlookMessage
          poppler-utils
          potrace
          (python3.withPackages (ps: [
            ps.markitdown
            ps.numpy
            ps.tinycss2
          ]))
          resvg
          (texliveBasic.withPackages (ps: [
            ps.dvisvgm
            ps.latex
            ps.latexmk
            ps.xetex
          ]))
          vips
        ]
      } \
      --add-flags "run --prefer-offline --no-install $out/dist/src/index.js"
  '';

  meta = {
    description = "Self-hosted online file converter";
    homepage = "https://github.com/C4illin/ConvertX/tree/main";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/C4illin/ConvertX/blob/main/CHANGELOG.md";
    mainProgram = pname;
    maintainers = with lib.maintainers; [
      EpicEric
    ];
  };
}
