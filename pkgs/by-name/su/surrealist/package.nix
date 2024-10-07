{ buildGoModule
, cairo
, cargo
, cargo-tauri
, esbuild
, fetchFromGitHub
, gdk-pixbuf
, glib-networking
, gobject-introspection
, lib
, libsoup_3
, makeBinaryWrapper
, nodejs
, openssl
, pango
, pkg-config
, pnpm
, rustc
, rustPlatform
, stdenv
, webkitgtk_4_1
}:

let
  cargo-tauri_2 = let
    version = "2.0.0-rc.3";
    src = fetchFromGitHub {
      owner = "tauri-apps";
      repo = "tauri";
      rev = "tauri-v${version}";
      hash = "sha256-PV8m/MzYgbY4Hv71dZrqVbrxmxrwFfOAraLJIaQk6FQ=";
    };
  in cargo-tauri.overrideAttrs (drv: {
    inherit src version;
    cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
      inherit src;
      name = "tauri-${version}-vendor.tar.gz";
      outputHash = "sha256-BrIH0JkGMp68O+4B+0g7X3lSdNSPXo+otlBgslCzPZE=";
    });
  });

  esbuild_21-5 = let
    version = "0.21.5";
  in esbuild.override {
    buildGoModule = args:
      buildGoModule (args // {
        inherit version;
        src = fetchFromGitHub {
          owner = "evanw";
          repo = "esbuild";
          rev = "v${version}";
          hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
        };
        vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
      });
  };

in stdenv.mkDerivation (finalAttrs: {
  pname = "surrealist";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealist";
    rev = "surrealist-v${finalAttrs.version}";
    hash = "sha256-jOjOdrVOcGPenFW5mkkXKA64C6c+/f9KzlvtUmw6vXc=";
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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) patches src;
    sourceRoot = finalAttrs.cargoRoot;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-LtQS0kH+2P4odV7BJYiH6T51+iZHAM9W9mV96rNfNWs=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-zGs1MWJ8TEFuHOoekCNIKQo2PBnp95xLz+R8mzeJXh8=";
  };

  nativeBuildInputs = [
    cargo
    (cargo-tauri.hook.override { cargo-tauri = cargo-tauri_2; })
    gobject-introspection
    makeBinaryWrapper
    nodejs
    pnpm.configHook
    pkg-config
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
