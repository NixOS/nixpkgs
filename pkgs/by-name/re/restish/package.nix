{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  restish,
  testers,
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
}:

buildGoModule (finalAttrs: {
  pname = "restish";
  version = "2.2.0";

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

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  checkFlags = [
    # Test requires network access  
    "-skip=TestAPISyncDiscoveryDoesNotSendAuthToCrossOriginLinkSpec"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests.version = testers.testVersion {
    package = restish;
    command = "HOME=$(mktemp -d) restish --version";
  };

  meta = {
    description = "CLI tool for interacting with REST-ish HTTP APIs";
    homepage = "https://rest.sh/";
    changelog = "https://github.com/danielgtaylor/restish/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "restish";
  };
})
