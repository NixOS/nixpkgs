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
  version = "4.16.0";
  gitCommit = "fa84651";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
    rev = "fa846511dbeb7e08cf77265056397283c6c896f9";
    hash = "sha256-mGItCpZQqQOKoNm2amwpHrEIcZdVNirQFa7DGvmnR9s=";
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

  meta = with lib; {
    description = "Build, deploy, and manage your applications with Docker and Kubernetes";
    homepage = "http://www.openshift.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      offline
      moretea
      stehessel
    ];
    mainProgram = "oc";
  };
}
