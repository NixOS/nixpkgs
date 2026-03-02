{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cloudfoundry-cli";
  version = "8.17.0";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OnUqREa2rYx/3yW+yZC69GTx/i7wtK4pLubAlGyYNSI=";
  };
  vendorHash = "sha256-FcymGl2dzCaZGEDpXyebffE3NbIgold8nKaZ+CW1p2o=";

  subPackages = [ "." ];

  # upstream have helpfully moved the bash completion script to a separate
  # repo which receives no releases or even tags
  bashCompletionScript = fetchurl {
    url = "https://raw.githubusercontent.com/cloudfoundry/cli-ci/5f4f0d5d01e89c6333673f0fa96056749e71b3cd/ci/installers/completion/cf8";
    sha256 = "06w26kpnjd3f2wdjhb4pp0kaq2gb9kf87v7pjd9n2g7s7qhdqyhy";
  };

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X code.cloudfoundry.org/cli/version.binaryBuildDate=1970-01-01"
    "-X code.cloudfoundry.org/cli/version.binaryVersion=${finalAttrs.version}"
  ];

  postInstall = ''
    mv "$out/bin/cli" "$out/bin/cf"
    installShellCompletion --bash $bashCompletionScript
  '';

  meta = {
    description = "Official command line client for Cloud Foundry";
    homepage = "https://github.com/cloudfoundry/cli";
    maintainers = with lib.maintainers; [ ris ];
    mainProgram = "cf";
    license = lib.licenses.asl20;
  };
})
