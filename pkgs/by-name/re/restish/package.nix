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
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C+fB9UeEq+h6SlBtVPPZWs5fCCsJVe/TJFy4KhhaItU=";
  };

  vendorHash = "sha256-5+N6iL9wD5J/E6H5qn1InQR8bbuAlTOzPQn0sawVbrI=";

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
