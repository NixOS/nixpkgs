{
  lib,
  stdenv,
  buildGo125Module,
  fetchFromGitHub,
  git,
  versionCheckHook,
  replaceVars,
  nix-update-script,
}:

buildGo125Module (finalAttrs: {
  pname = "garble";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = "garble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9Vjv5Eis+ALUm2aaXOj4i8w3UmylPggMXqgwXtD2YA8=";
  };

  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-buildid=00000000000000000000" # length=20
  ];

  patches = [
    (replaceVars ./0001-Add-version-info.patch {
      inherit (finalAttrs) version;
    })
  ];

  checkFlags = [
    "-skip"
    "TestScript/gogarble|TestScript/gotoolchain|TestScript/tiny"
  ];

  vendorHash = "sha256-EOmAb2k9LSzsvumsCZdeJIDKQBJBeRFt15mWAyyVl1k=";

  # Used for some of the tests.
  nativeCheckInputs = [
    git
    versionCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export WORK=$(mktemp -d)
  '';

  # Several tests fail with
  # FAIL: testdata/script/goenv.txtar:27: "$WORK/.temp 'quotes' and spaces" matches "garble|importcfg|cache\\.gob|\\.go"
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [
      davhau
      bot-wxt1221
    ];
    license = lib.licenses.bsd3;
    mainProgram = "garble";
  };
})
