{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  versionCheckHook,
  replaceVars,
  nix-update-script,
}:

buildGoModule rec {
  pname = "garble";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = "garble";
    tag = "v${version}";
    hash = "sha256-zS/K2kOpWhJmr0NuWSjEjNXV8ILt81yLIQWSPDuMwt8=";
  };

  __darwinAllowLocalNetworking = true;

  ldflags = [
    "-buildid=00000000000000000000" # length=20
  ];

  patches = [
    (replaceVars ./0001-Add-version-info.patch {
      inherit version;
    })
  ];

  checkFlags = [
    "-skip"
    "TestScript/gogarble"
  ];

  vendorHash = "sha256-xxG1aQrALVuJ7oVn+Z+sH655eFQ7rcYFmymGCUZD1uU=";

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
}
