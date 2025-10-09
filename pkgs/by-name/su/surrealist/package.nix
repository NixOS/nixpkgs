{
  buildGoModule,
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
  pnpm_9,
  rustc,
  rustPlatform,
  stdenv,
  webkitgtk_4_1,
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
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealist";
    rev = "surrealist-v${finalAttrs.version}";
    hash = "sha256-FWNGC0QoEUu1h3e3sfgWmbvqcNNvfWXU7PEjTXxu9Qo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-Su9ZOPIskV5poeS8pgtri+sZANBpdgnuCsQqE4WKFdA=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-oreeV9g16/F7JGLApi0Uq+vTqNhIg7Lg1Z4k00RUOYI=";
  };

  nativeBuildInputs = [
    cargo
    cargo-tauri.hook
    gobject-introspection
    jq
    makeBinaryWrapper
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
    rustc
    rustPlatform.cargoSetupHook
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

  meta = with lib; {
    description = "Visual management of your SurrealDB database";
    homepage = "https://surrealdb.com/surrealist";
    license = licenses.mit;
    mainProgram = "surrealist";
    maintainers = with maintainers; [ frankp ];
    platforms = platforms.linux;
  };
})
