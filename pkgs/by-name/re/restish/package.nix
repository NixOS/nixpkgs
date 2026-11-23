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
  version = "2.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rest-sh";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tI4o+zkKNnFrqWFEHsNt2+03Luth9KHH+x7P+WwaGNI=";
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
    # Tests require network access or use a hard-coded version string
    "-skip=TestAPISyncDiscoveryDoesNotSendAuthToCrossOriginLinkSpec|TestCommandSurfaceHideSupportCommands|TestVersion$|TestVersionCommand"
  ];

  doInstallCheck = true;

  meta = {
    description = "CLI tool for interacting with REST-ish HTTP APIs";
    homepage = "https://rest.sh/";
    changelog = "https://github.com/rest-sh/restish/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "restish";
  };
})
