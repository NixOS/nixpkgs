{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,
  openssl,
  webkitgtk_4_1,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gg";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "gulbanana";
    repo = "gg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmzALX1x7VfdnwN05bCwbnTL+HfFVyNiKFoT74tFuu8=";
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-esStQ55+T4uLbHbg7P7hqS6kIpXIMxouRSFkTo6dvAU=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yFDGH33maCndH4vgyMfNg0+c5jCOeoIAWUJgAPHXwsM=";
  };

  nativeBuildInputs =
    [
      cargo-tauri.hook
      nodejs
      npmHooks.npmConfigHook
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      wrapGAppsHook3
    ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      webkitgtk_4_1
    ];

  env.OPENSSL_NO_VENDOR = true;

  postInstall = lib.optionals stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s $out/Applications/gg.app/Contents/MacOS/gg $out/bin/gg
  '';

  # The generated Darwin bundle cannot be tested in the same way as a standalone Linux executable
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI for the version control system Jujutsu";
    homepage = "https://github.com/gulbanana/gg";
    changelog = "https://github.com/gulbanana/gg/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "gg";
  };
})
