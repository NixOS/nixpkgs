{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  nodejs,
  makeBinaryWrapper,
  cacert,
  # Runtime dependencies (converters)
  ffmpeg-full,
  imagemagick,
  graphicsmagick,
  libreoffice,
  pandoc,
  calibre,
  inkscape,
  ghostscript,
  poppler-utils,
  vips,
  libheif,
  potrace,
  resvg,
  assimp,
  vtracer,
  dasel,
  libjxl,
  mupdf,
  # , dcraw  # Marked insecure - enable with permittedInsecurePackages if needed
  # , texliveFull  # Large (~4GB) - enable for LaTeX support
  # Python dependencies for markitdown
  python3,
}:

let
  version = "0.16.1";

  # Python environment with markitdown
  pythonEnv = python3.withPackages (
    ps: with ps; [
      # markitdown dependencies
      numpy
      tinycss2
    ]
  );

  # Source from GitHub
  src = fetchFromGitHub {
    owner = "C4illin";
    repo = "ConvertX";
    rev = "v${version}";
    hash = "sha256-+9dV4Vxj8uVg7UG6CJpL4cKZot1UX7T8LdPauavG4+o=";
  };

  # Fixed-output derivation for node_modules
  # This allows caching of dependencies
  node_modules = stdenv.mkDerivation {
    pname = "convertx-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      cacert
    ];
    buildInputs = [ nodejs ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export HOME=$TMPDIR
      bun install --no-progress --frozen-lockfile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R ./node_modules $out/

      runHook postInstall
    '';

    # Fixed output derivation settings
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-JzKbMk6mvnd+zOhFqSmCzGE4v5vOuUbKQLDE7Nk5/es=";
  };

in
stdenv.mkDerivation rec {
  pname = "convertx";
  inherit version src;

  nativeBuildInputs = [
    bun
    nodejs
    makeBinaryWrapper
  ];

  buildInputs = [
    # All converter tools need to be available at runtime
    ffmpeg-full
    imagemagick
    graphicsmagick
    libreoffice
    pandoc
    calibre
    inkscape
    ghostscript
    poppler-utils
    vips
    libheif
    potrace
    resvg
    assimp
    vtracer
    dasel
    libjxl
    mupdf
    # dcraw  # Insecure
    # texliveFull  # Large - uncomment for LaTeX
    pythonEnv
  ];

  configurePhase = ''
    runHook preConfigure

    # Copy pre-built node_modules
    cp -R ${node_modules}/node_modules .
    chmod -R u+w node_modules

    # Patch shebangs for sandbox (no /usr/bin/env)
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    # Run tailwindcss directly from node_modules (bun x tries to download)
    ./node_modules/.bin/tailwindcss -i ./src/main.css -o ./public/generated.css

    # Run TypeScript compiler
    bun run build:js

    # Patch hardcoded ./data paths to use DATA_DIR environment variable
    # This allows the NixOS service to configure the data directory
    substituteInPlace dist/src/db/db.js \
      --replace-fail 'mkdirSync("./data"' 'mkdirSync((process.env.DATA_DIR || "./data")' \
      --replace-fail '"./data/mydb.sqlite"' '((process.env.DATA_DIR || "./data") + "/mydb.sqlite")'

    # Patch the uploads and output directory paths in index.js
    substituteInPlace dist/src/index.js \
      --replace-fail '"./data/uploads/"' '((process.env.DATA_DIR || "./data") + "/uploads/")' \
      --replace-fail '"./data/output/"' '((process.env.DATA_DIR || "./data") + "/output/")'

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/convertx
        mkdir -p $out/bin

        # Copy built application
        cp -R dist $out/lib/convertx/
        cp -R public $out/lib/convertx/
        cp -R node_modules $out/lib/convertx/
        cp package.json $out/lib/convertx/

        # Create wrapper script with all converters in PATH
        # Uses shell script to capture original cwd for DATA_DIR before chdir
        cat > $out/bin/convertx << 'WRAPPER'
    #!/bin/sh
    # ConvertX wrapper - sets up environment and runs the server
    # DATA_DIR defaults to current directory's ./data if not set
    export DATA_DIR="''${DATA_DIR:-$(pwd)/data}"
    export NODE_ENV="''${NODE_ENV:-production}"
    export QTWEBENGINE_CHROMIUM_FLAGS="''${QTWEBENGINE_CHROMIUM_FLAGS:---no-sandbox}"
    WRAPPER

        # Add PATH with all converters
        echo "export PATH=\"${
          lib.makeBinPath [
            ffmpeg-full
            imagemagick
            graphicsmagick
            libreoffice
            pandoc
            calibre
            inkscape
            ghostscript
            poppler-utils
            vips
            libheif
            potrace
            resvg
            assimp
            vtracer
            dasel
            libjxl
            mupdf
            pythonEnv
          ]
        }:\$PATH\"" >> $out/bin/convertx

        # Change to lib directory and run bun
        cat >> $out/bin/convertx << WRAPPER
    cd $out/lib/convertx
    exec ${bun}/bin/bun run dist/src/index.js "\$@"
    WRAPPER

        chmod +x $out/bin/convertx

        runHook postInstall
  '';

  meta = with lib; {
    description = "Self-hosted online file converter supporting 1000+ formats";
    homepage = "https://github.com/C4illin/ConvertX";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ericwheeler ];
    platforms = platforms.linux;
    mainProgram = "convertx";
  };
}
