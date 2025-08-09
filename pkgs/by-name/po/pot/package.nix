{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  wrapGAppsHook3,
  cargo,
  rustc,
  cargo-tauri_1,
  pkg-config,
  esbuild,
  buildGoModule,
  libayatana-appindicator,
  gtk3,
  webkitgtk_4_0,
  libsoup_2_4,
  openssl,
  xdotool,
}:

let
  pnpm = pnpm_9;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pot";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "pot-app";
    repo = "pot-desktop";
    tag = finalAttrs.version;
    hash = "sha256-0Q1hf1AGAZv6jt05tV3F6++lzLpddvjhiykIhV40cPs=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-iYQNGRWqXYBU+WIH/Xm8qndgOQ6RKYCtAyi93kb7xrQ=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-dyXINRttgsqCfmgtZNXxr/Rl8Yn0F2AVm8v2Ao+OBsw=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri_1.hook
    nodejs
    pnpm.configHook
    wrapGAppsHook3
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup_2_4
    libayatana-appindicator
    openssl
    webkitgtk_4_0
    xdotool
  ];

  env.ESBUILD_BINARY_PATH = "${lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // rec {
            version = "0.21.5";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              tag = "v${version}";
              hash = "sha256-FpvXWIlt67G8w3pBKZo/mcp57LunxDmRUaCU/Ne89B8=";
            };
          }
        );
    }
  )}";

  meta = {
    description = "Cross-platform translation software";
    mainProgram = "pot";
    homepage = "https://pot-app.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ linsui ];
  };
})
