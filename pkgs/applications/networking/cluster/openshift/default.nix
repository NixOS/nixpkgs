{ lib
, buildGoModule
, fetchFromGitHub
, gpgme
, installShellFiles
, pkg-config
, testers
, openshift
}:
buildGoModule rec {
  pname = "openshift";
  version = "4.14.0";
  gitCommit = "0c63f9d";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "oc";
    rev = "0c63f9da2694c080257111616c60005f32a5bf47";
    hash = "sha256-viNSRwGNB0TGgw501cQuj4ajmAgvqk4vj2RmW8/DCB8=";
  };

  vendorHash = null;

  buildInputs = [ gpgme ];

  nativeBuildInputs = [ installShellFiles pkg-config ];

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
    maintainers = with maintainers; [ offline bachp moretea stehessel ];
    mainProgram = "oc";
  };
}
