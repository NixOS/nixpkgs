{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  lib,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gqlgenc";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AGbE+R3502Igl4/HaN8yvFVJBsKQ6iVff8IEvddJLEo=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-version.patch";
      url = "https://github.com/Yamashou/gqlgenc/commit/aad0599a70780696a9530a7adffebfff53538695.patch?full_index=1";
      hash = "sha256-moidhkkO/5It8kH1VlwbV+YLlMOTXKH3RyLKGCA2chw=";
    })
  ];

  excludedPackages = [ "example" ];

  vendorHash = "sha256-kBv9Kit5KdPB48V/g1OaeB0ABFd1A1I/9F5LaQDWxUE=";

  ldflags = [
    "-X"
    "main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  # FAIL: TestLoadConfig_LoadSchema/correct_schema
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wattmto ];
  };
})
