{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5/KWAytz0SQYgIerf1xyTfJxzX5ynA2BhKfbYmu/vU8=";
  };

  vendorHash = "sha256-LzuY3l6QQnMtAoVM2i206BuoTkVLVHg1DTWZhjIepY8=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # utils_test.go:62: route ip+net: no such network interface
    # does not work in sandbox even with __darwinAllowLocalNetworking
    "-skip=^TestGetIPv4Addr$"
  ];

  meta = {
    description = "Simple, yet feature-rich web server written in Go";
    homepage = "https://goshs.de";
    changelog = "https://github.com/patrickhener/goshs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      matthiasbeyer
      seiarotg
    ];
    mainProgram = "goshs";
  };
})
