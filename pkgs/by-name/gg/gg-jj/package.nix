{
  lib,
  stdenv,

  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  yq,

  cargo-tauri,
  cargo,
  rustc,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  openssl,
  webkitgtk_4_1,

  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gg";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "gulbanana";
    repo = "gg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iQxPJgMxBtyindkNdQkehwPf7ZgWCI09PToqs2y1Hfw=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  # FIXME: Switch back to cargoHash when https://github.com/NixOS/nixpkgs/issues/356811 is fixed
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-IyU8dqtQbKcoymTOP01givB1968MUNas2znqsdbcqdw=";

    nativeBuildInputs = [ yq ];

    # Work around https://github.com/rust-lang/cargo/issues/10801
    # See https://discourse.nixos.org/t/rust-tauri-v2-error-no-matching-package-found/56751/4
    preBuild = ''
      tomlq -it '.dependencies.tauri.features += ["native-tls"]' Cargo.toml
    '';
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-SMz1ohPSF5tvf2d3is4PXhnjHG9hHuS5NYmHbe46HaU=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    nodejs
    npmHooks.npmConfigHook
    pkg-config
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
    changelog = "https://github.com/gulbanana/gg/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "gg";
  };
})
