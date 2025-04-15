{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-RGHfDrFr2HO4i+YQeNzYrEcU+Xe286f3f5g/yUmpxpA=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-h3ePmfRkGqVXdtjX2cU5y2HnX+VkmTWNwrEkhLAmrlU=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  # FAIL: TestLoadConfig_LoadSchema/correct_schema
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ wattmto ];
  };
}
