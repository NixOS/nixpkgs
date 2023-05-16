{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-js/UjnNYRW7s3b4TeprhmBe4cDLDYDrMeLtpASI9aN4=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-oEbKk9cMbI0ZWXrfM8Y19OF/A75mwHl0C/PJx0oTOBo=";
=======
  vendorSha256 = "sha256-oEbKk9cMbI0ZWXrfM8Y19OF/A75mwHl0C/PJx0oTOBo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-s" "-w"
    "-X github.com/splunk/qbec/internal/commands.version=${version}"
    "-X github.com/splunk/qbec/internal/commands.commit=${src.rev}"
    "-X github.com/splunk/qbec/internal/commands.goVersion=${lib.getVersion go}"
  ];

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
