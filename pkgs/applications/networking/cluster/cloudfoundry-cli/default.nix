{ lib, buildGoModule, fetchFromGitHub, fetchurl, installShellFiles }:

buildGoModule rec {
  pname = "cloudfoundry-cli";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-I+4tFAMmmsmi5WH9WKXIja1vVWsPHNGkWbvjWGUCmkU=";
  };
  # vendor directory stale
  deleteVendor = true;
  vendorSha256 = null;

  subPackages = [ "." ];

  # upstream have helpfully moved the bash completion script to a separate
  # repo which receives no releases or even tags
  bashCompletionScript = fetchurl {
    url = "https://raw.githubusercontent.com/cloudfoundry/cli-ci/6087781a0e195465a35c79c8e968ae708c6f6351/ci/installers/completion/cf7";
    sha256 = "1vhg9jcgaxcvvb4pqnhkf27b3qivs4d3w232j0gbh9393m3qxrvy";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X code.cloudfoundry.org/cli/version.binaryBuildDate=1970-01-01"
    "-X code.cloudfoundry.org/cli/version.binaryVersion=${version}"
  ];

  postInstall = ''
    mv "$out/bin/cli" "$out/bin/cf"
    installShellCompletion --bash $bashCompletionScript
  '';

  meta = with lib; {
    description = "The official command line client for Cloud Foundry";
    homepage = "https://github.com/cloudfoundry/cli";
    maintainers = with maintainers; [ ris ];
    license = licenses.asl20;
  };
}
