{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  git,
  versionCheckHook,
  replaceVars,
  nix-update-script,
}:
# garble has strict go version requirements; we should pin the go version
# directly prior to the first unsupported version as described in the
# `goVersionOK()` function
# https://github.com/burrowers/garble/blob/v0.17.0/main.go#L536
buildGo126Module (finalAttrs: {
  pname = "garble";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = "garble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yIdyvKxqlrYp77biXUiCrvMyTFStafkB+y5QF1M0CEg=";
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

  checkFlags =
    let
      skippedTests = [
        # tries to mess with the installed go toolchain
        "TestScript/gotoolchain"
        # requires parts of a 32-bit glibc on some platforms
        "TestScript/atomic"
        # passes an `-arch` flag to gcc which does not exist
        "TestScript/crossbuild"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = "sha256-F0Jc15ulA+qRDZu5W3FU9dZ+oXq8lGXP4dQeWnZwYbk=";

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
