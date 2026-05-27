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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4piN0W/9y2NTsTuZ2B4Czhr9RQNb4eT9ZIX9MYzfMLI=";
  };

  vendorHash = "sha256-ZRyGCdmPenOeLtFuj0howJH0rah05sPUuD7RH/c0LKI=";

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
