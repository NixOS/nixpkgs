{
  buildGoModule,
  bun,
  cairo,
  cargo-tauri,
  cargo,
  esbuild,
  fetchFromGitHub,
  gdk-pixbuf,
  glib-networking,
  gobject-introspection,
  jq,
  lib,
  libsoup_3,
  makeBinaryWrapper,
  moreutils,
  nodejs,
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
  esbuild_21-5 =
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "surrealist";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealist";
    rev = "surrealist-v${finalAttrs.version}";
    hash = "sha256-L2O3iMoNptNgzEy7gXptAaHXhv4J5ED/72GLrH43/kQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-NhgSfiBb4FGEnirpDFWI3MIMElen8frKDFKmCBJlSBY=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "surrealist-node_modules";
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];
    dontConfigure = true;
    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install --no-progress --frozen-lockfile --no-cache

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
        x86_64-linux = "sha256-tZYIiWHaeryV/f9AFNknRZp8om0y8QH8RCxoqgmbR5g=";
        aarch64-linux = "sha256-6nB8wcXIYR1WcYqZrNFl0Jfdz/Z3PttULQHsQcfAsOk=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet. Supported platforms: x86_64-linux, aarch64-linux.");
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    cargo
    cargo-tauri.hook
    gobject-introspection
    jq
    makeBinaryWrapper
    moreutils
    nodejs
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    typescript
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    libsoup_3
    openssl
    pango
    webkitgtk_4_1
  ];

  env = {
    ESBUILD_BINARY_PATH = lib.getExe esbuild_21-5;
    OPENSSL_NO_VENDOR = 1;
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  # Deactivate the upstream update mechanism
  postPatch = ''
    jq '
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater = {"active": false, "pubkey": "", "endpoints": []}
    ' \
    src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  postFixup = ''
    wrapProgram "$out/bin/surrealist" \
      --set GIO_EXTRA_MODULES ${glib-networking}/lib/gio/modules \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    # Bun takes executables from this folder
    chmod -R u+rw node_modules
    chmod -R u+x node_modules/.bin
    patchShebangs node_modules

    export HOME=$TMPDIR
    export PATH="$PWD/node_modules/.bin:$PATH"

    runHook postConfigure
  '';

  meta = with lib; {
    description = "Visual management of your SurrealDB database";
    homepage = "https://surrealdb.com/surrealist";
    license = licenses.mit;
    mainProgram = "surrealist";
    maintainers = with maintainers; [
      frankp
      dmitriiStepanidenko
    ];
    platforms = platforms.linux;
  };
})
