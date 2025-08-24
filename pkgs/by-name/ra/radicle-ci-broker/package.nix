{
  lib,
  rustPlatform,
  fetchFromRadicle,
  fetchRadiclePatch,
  stdenv,
  jq,
  gitMinimal,
  sqlite,
  radicle-node,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-ci-broker";
  version = "0.20.0";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "zwTxygwuz5LDGBq255RA2CbNGrz8";
    node = "z6MkgEMYod7Hxfy9qCvDv5hYHkZ4ciWmLFgfvm3Wn1b2w2FV";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2j7vZE+0GkYB+XrzeKYPTb2JgoqHjQOhorCXRQD9PbY=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git_head
      rm -rf $out/.git
    '';
  };

  cargoHash = "sha256-3DHUV0ZglUAJsyUE1Lz1+CxRBbS4NTyVLBJynBSfqkw=";

  patches = [
    # https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwTxygwuz5LDGBq255RA2CbNGrz8/patches/11975f3f94628d43f49fbfb03d5e4ecee7e3da32
    (fetchRadiclePatch {
      inherit (finalAttrs.src) seed repo;
      revision = "11975f3f94628d43f49fbfb03d5e4ecee7e3da32";
      hash = "sha256-3/rz8ecJDeYFMD899yjOuoCRfFggHjgfjxBB7BfZDms=";
    })
  ];

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail "let hash = " "let hash = \"$(<$src/.git_head)\"; "
  '';

  preCheck = ''
    ln -s "$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType" target/debug
  '';

  nativeCheckInputs = [
    jq
    gitMinimal
    sqlite
    radicle-node
  ];

  checkFlags = [
    "--skip=acceptance_criteria_for_upgrades"
    "--skip=logs_adapter_stderr_output"
    "--skip=process_queued_events"
    "--skip=runs_adapter_with_configuration"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Radicle CI broker";
    homepage = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwTxygwuz5LDGBq255RA2CbNGrz8";
    changelog = "https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:zwTxygwuz5LDGBq255RA2CbNGrz8/tree/NEWS.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "cib";
  };
})
