{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libx11,
  libxcursor,
  libxi,
  libxinerama,
  libxrandr,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "restish";
  version = "2.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wGchbKSEbzr1vQlYWgUTubA1xQVcxq7iyRUIuWqVL0Y=";
  };

  vendorHash = "sha256-Y0GwgrkD09WAlmyI6Oe3Kw6L62E7QRTCIThZGXbbn74=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxcursor
    libxi
    libxinerama
    libxrandr
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-X=github.com/rest-sh/restish/v2/internal/cli.Version=${finalAttrs.version}"
  ];

  checkFlags = [
    # Test requires network access and test with hard-coded version '2.0.0'
    "-skip=TestAPISyncDiscoveryDoesNotSendAuthToCrossOriginLinkSpec|TestVersion$|TestVersionCommand"
  ];

  doInstallCheck = true;

  meta = {
    description = "CLI tool for interacting with REST-ish HTTP APIs";
    homepage = "https://rest.sh/";
    changelog = "https://github.com/danielgtaylor/restish/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "restish";
  };
})
