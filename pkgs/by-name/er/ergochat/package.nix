{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "ergo";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "ergochat";
    repo = "ergo";
    rev = "v${version}";
    sha256 = "sha256-ajLecAgE74Et7XRGtpGoA9DAcSzBEtRzLm47nHn1Amo=";
  };

  vendorHash = null;

  passthru.tests.ergochat = nixosTests.ergochat;

  meta = {
    changelog = "https://github.com/ergochat/ergo/blob/v${version}/CHANGELOG.md";
    description = "Modern IRC server (daemon/ircd) written in Go";
    mainProgram = "ergo";
    homepage = "https://github.com/ergochat/ergo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lassulus
      tv
    ];
    platforms = lib.platforms.linux;
  };
}
