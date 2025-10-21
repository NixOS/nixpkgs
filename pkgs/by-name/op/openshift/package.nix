{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gpgme,
  installShellFiles,
  pkg-config,
  testers,
  openshift,
}:
buildGoModule rec {
  pname = "openshift";
  version = "4.19.0-202505210330";
  gitCommit = "8f1c8b5";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
    tag = "openshift-clients-${version}";
    hash = "sha256-EIsK73zSozqBOFZalURNcamk5FRDusUEhXtup60c2zQ=";
  };

  vendorHash = null;

  buildInputs = [ gpgme ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/openshift/oc/pkg/version.commitFromGit=${gitCommit}"
    "-X github.com/openshift/oc/pkg/version.versionFromGit=v${version}"
  ];

  doCheck = false;

  postInstall = ''
    # Install man pages.
    mkdir -p man
    $out/bin/genman man oc
    installManPage man/*.1

    # Remove unwanted tooling.
    rm $out/bin/clicheck $out/bin/gendocs $out/bin/genman

    # Install shell completions.
    installShellCompletion --cmd oc \
      --bash <($out/bin/oc completion bash) \
      --fish <($out/bin/oc completion fish) \
      --zsh <($out/bin/oc completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = openshift;
    command = "oc version";
    version = "v${version}";
  };

  meta = {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    homepage = "http://www.openshift.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      offline
      moretea
      stehessel
    ];
    mainProgram = "oc";
  };
}
