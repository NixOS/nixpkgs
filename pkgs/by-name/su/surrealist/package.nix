{
  bun,
  buildGoModule,
  cairo,
  cargo,
  cargo-tauri,
  esbuild,
  fetchFromGitHub,
  gdk-pixbuf,
  glib-networking,
  gobject-introspection,
  jq,
  lib,
  libsoup_3,
  makeBinaryWrapper,
  makeWrapper,
  moreutils,
  nodejs_24,
  openssl,
  pango,
  pkg-config,
  rustc,
  rustPlatform,
  stdenv,
  typescript,
  webkitgtk_4_1,
  writableTmpDirAsHomeHook,
}:
let
  pname = "surrealist";
  version = "3.6.15";
  appName = "Surrealist";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealist";
    rev = "surrealist-v${version}";
    hash = "sha256-AsA5p3ViwtBUBOw8Bj4okGsy3ImCcSz7Ctd0WJ2wBkE=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/src-tauri";
    hash = "sha256-NhgSfiBb4FGEnirpDFWI3MIMElen8frKDFKmCBJlSBY=";
  };

  esBuild =
    let
      version = "0.21.5";
    in
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // {
            inherit version;
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    };

  # build node modules in derivation to handle @codemirror dependencies
  bunDeps = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "surrealist-node_modules";
    nativeBuildInputs = [
      jq
      moreutils
      bun
      writableTmpDirAsHomeHook
    ];
    dontConfigure = true;
    buildPhase = ''
       runHook preBuild

      ${lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
        jq '.overrides.rollup = "npm:@rollup/wasm-node@4.56.0"' package.json | sponge package.json
      ''}

       export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
       bun install --no-progress --no-cache

       runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';
    outputHash =
      {
        aarch64-darwin = "sha256-4rzKzfcIhjqYovn0lXlBMems5NiQ1I6uhA32VXFvPqk=";
        aarch64-linux = "sha256-5JySFDALOTk2Cfk1gQ+q6ItekRaDBzZYh5p9WXkoj4o=";
        x86_64-linux = "sha256-xcHTMjIfDxVeVL22eR2C8NJZtues0M2Kbw+VYobK6U8=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet. Please consider adding it.");
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    jq
    moreutils
    pkg-config
    bun
    nodejs_24
    typescript
    rustc
    cargo
    cargo-tauri
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gobject-introspection
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
  ];

  buildInputs = [
    cairo
    openssl
    pango
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gdk-pixbuf
    glib-networking
    libsoup_3
    webkitgtk_4_1
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    ESBUILD_BINARY_PATH = lib.getExe finalAttrs.esBuild;
  };

  postPatch = ''
    # Only build the app, not other packages (prevent dmg build on darwin)
    jq '
      .bundle.targets = ["app"] |
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.bunDeps}/node_modules .
    chmod -R u+w node_modules
    chmod -R u+x node_modules/.bin
    patchShebangs node_modules

    export HOME=$TMPDIR
    export PATH="$PWD/node_modules/.bin:$PATH"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export CARGO_TARGET_DIR="$(pwd)/target"
    pushd src-tauri
    cargo tauri build --bundles ${if stdenv.hostPlatform.isDarwin then "app" else "deb"}
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r ./target/release/bundle/macos/${appName}.app $out/Applications/
          mkdir -p $out/bin
          makeWrapper "$out/Applications/${appName}.app/Contents/MacOS/${appName}" $out/bin/${pname}
        ''
      else
        ''
          mkdir -p $out
          cp -r ./target/release/bundle/deb/*/data/usr/* $out/
        ''
    }

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram "$out/bin/surrealist" \
      --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = {
    description = "Visual management of your SurrealDB database";
    homepage = "https://surrealdb.com/surrealist";
    downloadPage = "https://github.com/surrealdb/surrealist/releases";
    license = lib.licenses.mit;
    mainProgram = "surrealist";
    maintainers = with lib.maintainers; [
      frankp
      dmitriiStepanidenko
      smissingham
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
