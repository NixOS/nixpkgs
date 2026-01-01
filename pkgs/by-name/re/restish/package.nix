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
<<<<<<< HEAD
  version = "0.21.2";
=======
  version = "0.21.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "danielgtaylor";
    repo = "restish";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-C+fB9UeEq+h6SlBtVPPZWs5fCCsJVe/TJFy4KhhaItU=";
  };

  vendorHash = "sha256-5+N6iL9wD5J/E6H5qn1InQR8bbuAlTOzPQn0sawVbrI=";
=======
    hash = "sha256-eLbeH6i+QbW59DMOHf83olrO8R7Ji975KkJKs621Xi0=";
  };

  vendorHash = "sha256-bO0z+LCiF/Dp0hKNulBmCgk16NzCCoY32P2/Ieq8y+c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
