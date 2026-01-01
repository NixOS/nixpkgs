{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "saucectl";
<<<<<<< HEAD
  version = "0.197.4";
=======
  version = "0.197.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "saucelabs";
    repo = "saucectl";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vhVgrwZ+CXKDkJTQ0eCZM83FjvmNI6cxcRcxTspHtCE=";
=======
    hash = "sha256-aAEqYfCBsXMxjkJHUrKBh2y3ma6r2rVaQfY2PqsLVDA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  ldflags = [
    "-X github.com/saucelabs/saucectl/internal/version.Version=${version}"
    "-X github.com/saucelabs/saucectl/internal/version.GitCommit=${version}"
  ];

  vendorHash = "sha256-n/GblPFolUD+noxGI4yZbOGdAUxM0DXtpCybS+E0k3I=";

  checkFlags = [ "-skip=^TestNewRequestWithContext$" ];

  meta = {
    description = "Command line interface for the Sauce Labs platform";
    changelog = "https://github.com/saucelabs/saucectl/releases/tag/v${version}";
    homepage = "https://github.com/saucelabs/saucectl";
    license = lib.licenses.apsl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "saucectl";
  };
}
