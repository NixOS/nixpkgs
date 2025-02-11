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
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealist";
    rev = "surrealist-v${finalAttrs.version}";
    hash = "sha256-p+Tyu65A+vykqafu1RCRKYFXb435Uyu9WxUoEqjI8d8=";
  };

  # HACK: A dependency (surrealist -> tauri -> **reqwest**) contains hyper-tls
  # as an actually optional dependency. It ends up in the `Cargo.lock` file of
  # tauri, but not in the one of surrealist. We apply a patch to `Cargo.toml`
  # and `Cargo.lock` to ensure that we have it in our vendor archive. This may
  # be a result of the following bug:
  # https://github.com/rust-lang/cargo/issues/10801
  patches = [
    ./0001-Cargo.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) patches src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-qrPIcWpdrvTmaFcfKAfz+n8a6lp6IcIMq9ZCHaa7AHQ=";
    patchFlags = [ "-p2" ];
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JwOY6Z8UjbrodSQ3csnT+puftbQUDF3NIK7o6rSpl2o=";
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
    description = "Surrealist is the ultimate way to visually manage your SurrealDB database";
    homepage = "https://surrealdb.com/surrealist";
    license = licenses.mit;
    mainProgram = "surrealist";
    maintainers = with maintainers; [ frankp ];
    platforms = platforms.linux;
  };
})
