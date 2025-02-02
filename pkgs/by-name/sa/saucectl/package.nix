{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  pname = "saucectl";
  version = "0.190.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "saucelabs";
    repo = "saucectl";
    rev = "refs/tags/v${version}";
    hash = "sha256-P7aERLPpaxYyr1W7bhgz/44eD1719hXsHjax5uxVJ9g=";
  };

  ldflags = [
    "-X github.com/saucelabs/saucectl/internal/version.Version=${version}"
    "-X github.com/saucelabs/saucectl/internal/version.GitCommit=${version}"
  ];

  vendorHash = "sha256-RbZmCBhBMRq4Z6t0L1H4r8/9V/mdKC+GtoaFuokFy84=";

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
