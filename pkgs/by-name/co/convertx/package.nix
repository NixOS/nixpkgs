{
  stdenvNoCC,
  lib,
  fetchFromGitHub,

  # Build deps
  bun,
  tailwindcss_4,
  makeBinaryWrapper,

  # Runtime deps
  assimp,
  calibre,
  dasel,
  djvulibre,
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

  node_modules = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${pname}-node_modules";
    inherit version src;

    dontConfigure = true;
    dontFixup = true;

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

    outputHash = pin."${stdenvNoCC.system}";
    outputHashMode = "recursive";
  });
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    makeBinaryWrapper
    tailwindcss_4
    bun
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    ln -s ${node_modules}/lib/node_modules ./node_modules
    tailwindcss -i ./src/main.css -o ./public/generated.css

    substituteInPlace ./src/index.tsx \
      --replace-fail "assets: \"public\"" "assets: \"$out/share/convertx/public\""

    bun build --compile --minify --sourcemap --bytecode --format=esm \
      --define 'process.env.NODE_ENV=\"production\"' \
      src/index.tsx \
      --outfile $out/bin/convertx

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share/convertx
    cp -R ./public $out/share/convertx

    wrapProgram $out/bin/convertx \
      --suffix PATH : ${
        lib.makeBinPath [
          assimp
          calibre
          dasel
          djvulibre
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
          (python3.withPackages (ps: [ ps.markitdown ] ++ ps.markitdown.optional-dependencies.all))
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    changelog = "https://github.com/C4illin/ConvertX/blob/main/CHANGELOG.md";
    mainProgram = "convertx";
    maintainers = with lib.maintainers; [
      EpicEric
    ];
  };
}
