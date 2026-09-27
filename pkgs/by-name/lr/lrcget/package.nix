{
  lib,
  stdenv,
  rustPlatform,

  fetchFromGitHub,
  fetchNpmDeps,

  cargo-tauri,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  alsa-lib,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lrcget";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "tranxuanthang";
    repo = "lrcget";
    tag = version;
    hash = "sha256-cxQpCuyFsJeujcL2TPMH7n+Q6l4h+P1HvsrMoFmbWMI=";
  };

  patches = [
    # needed to not attempt codesigning on darwin
    ./remove-signing-identity.patch
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-9vyvRJsR4o7kWSLJyGIoiM/13ABWWTrRXVdyU2HfJ+E=";

  # FIXME: This is a workaround, because we have a git dependency node_modules/lrc-kit contains install scripts
  # but has no lockfile, which is something that will probably break.
  forceGitDeps = true;

  npmDeps = fetchNpmDeps {
    name = "lrcget-${version}-npm-deps";
    inherit src forceGitDeps patches;
    hash = "sha256-yXRbQ6xM23VrVaS8Hb5sxPPic1yawKtFi2rCGkplgw4=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    alsa-lib
    openssl
    webkitgtk_4_1
  ];

  # To fix `npm ERR! Your cache folder contains root-owned files`
  makeCacheWritable = true;

  # Disable checkPhase, since the project doesn't contain tests
  doCheck = false;

  # make the binary also runnable from the shell
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out/Applications/LRCGET.app/Contents/MacOS/LRCGET" "$out/bin/LRCGET"
  '';

  preFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    gappsWrapperArgs+=(
      # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility for mass-downloading LRC synced lyrics for your offline music library";
    homepage = "https://github.com/tranxuanthang/lrcget";
    changelog = "https://github.com/tranxuanthang/lrcget/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anas
      Scrumplex
    ];
    mainProgram = "LRCGET";
    platforms = with lib.platforms; unix ++ windows;
  };
}
