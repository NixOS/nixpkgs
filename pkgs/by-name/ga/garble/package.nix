{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  diffoscope,
  git,
  versionCheckHook,
  replaceVars,
  nix-update-script,
}:

buildGoModule rec {
  pname = "garble";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = "garble";
    rev = "refs/tags/v${version}";
    hash = "sha256-FtI5lAeqjRPN47iC46bcEsRLQb7mItw4svsnLkRpNxY=";
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

  vendorHash = "sha256-mSdajYiMEg2ik0ocfmHK+XddEss1qLu6rDwzjocaaW0=";

  # Used for some of the tests.
  nativeCheckInputs = [
    diffoscope
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
  versionCheckProgramArg = [ "version" ];
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
