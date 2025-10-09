{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  restish,
  testers,
  xorg,
}:

buildGoModule rec {
  pname = "restish";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    tag = "v${version}";
    hash = "sha256-eLbeH6i+QbW59DMOHf83olrO8R7Ji975KkJKs621Xi0=";
  };

  vendorHash = "sha256-bO0z+LCiF/Dp0hKNulBmCgk16NzCCoY32P2/Ieq8y+c=";

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
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
    changelog = "https://github.com/danielgtaylor/restish/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "restish";
  };
}
