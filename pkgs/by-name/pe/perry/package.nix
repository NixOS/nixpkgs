{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenvNoCC,
  deno,
  gtk4,
  makeBinaryWrapper,
  clang,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "perry";
  version = "0.5.345";

  src = fetchFromGitHub {
    owner = "PerryTS";
    repo = "perry";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mgqk/savFP8FB3SN4IPqCV1bljJXT2gXDUAV01C4Tw8=";
  };

  cargoHash = "sha256-eE0f2P0ldSIeuJ0OzrtCbaRHNsg/g8ENT2TMbGWFLRw=";

  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "perry-ui-ios"
    "--exclude"
    "perry-ui-visionos"
    "--exclude"
    "perry-ui-tvos"
    "--exclude"
    "perry-ui-watchos"
    "--exclude"
    "perry-ui-gtk4"
    "--exclude"
    "perry-ui-android"
    "--exclude"
    "perry-ui-windows"
  ];

  env.RUSTY_V8_ARCHIVE = deno.librusty_v8;

  buildInputs = lib.optionals stdenvNoCC.isLinux [ gtk4 ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath [ clang ]} \
      --prefix LD_LIBRARY_PATH : $out/lib
    rm -f $out/bin/styling-matrix
  '';

  __structuredAttrs = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native TypeScript compiler written in Rust";
    homepage = "https://www.perryts.com";
    downloadPage = "https://github.com/PerryTS/perry/releases";
    changelog = "https://github.com/PerryTS/perry/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # librusty_v8.a
    ];
    mainProgram = "perry";
    hydraPlatforms = lib.lists.remove "x86_64-darwin" lib.platforms.all;
  };
})
