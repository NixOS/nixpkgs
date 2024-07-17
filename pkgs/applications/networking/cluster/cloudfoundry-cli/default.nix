{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cloudfoundry-cli";
  version = "8.7.11";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-7FYIJf9vNHK9u8r7HVpPtGGWwRA5cdrB9f1Vz1iTFjI=";
  };
  vendorHash = "sha256-9SpmMXmocwaZH4fqqETzmRP6wvI2NV/LL6M0Ld4lvso=";

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
    "-X code.cloudfoundry.org/cli/version.binaryVersion=${version}"
  ];

  postInstall = ''
    mv "$out/bin/cli" "$out/bin/cf"
    installShellCompletion --bash $bashCompletionScript
  '';

  meta = with lib; {
    description = "Official command line client for Cloud Foundry";
    homepage = "https://github.com/cloudfoundry/cli";
    maintainers = with maintainers; [ ris ];
    mainProgram = "cf";
    license = licenses.asl20;
  };
}
