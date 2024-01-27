{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "prow-unstable";
  version = "2020-04-01";
  rev = "32e3b5ce7695fb622381421653db436cb57b47c5";

  src = fetchFromGitHub {
    inherit rev;

    owner = "kubernetes";
    repo = "test-infra";
    hash = "sha256-ZNa7iAcN1qlBFT/UfziivW4q+9hjIt9WbHEOt6r1g1U=";
  };

  vendorHash = "sha256-FJO8KVCZLehaN1Eku6uQpj/vgwOyO+Irqs0qJHJhzZk=";

  doCheck = false;

  subPackages = [
    "prow/cmd/admission"
    "prow/cmd/branchprotector"
    "prow/cmd/checkconfig"
    "prow/cmd/clonerefs"
    "prow/cmd/cm2kc"
    "prow/cmd/config-bootstrapper"
    "prow/cmd/crier"
    "prow/cmd/deck"
    "prow/cmd/entrypoint"
    "prow/cmd/exporter"
    "prow/cmd/gcsupload"
    "prow/cmd/gerrit"
    "prow/cmd/hook"
    "prow/cmd/horologium"
    "prow/cmd/initupload"
    "prow/cmd/jenkins-operator"
    "prow/cmd/mkbuild-cluster"
    "prow/cmd/mkpj"
    "prow/cmd/mkpod"
    "prow/cmd/peribolos"
    "prow/cmd/phaino"
    "prow/cmd/phony"
    "prow/cmd/pipeline"
    "prow/cmd/plank"
    "prow/cmd/sidecar"
    "prow/cmd/sinker"
    "prow/cmd/status-reconciler"
    "prow/cmd/sub"
    "prow/cmd/tackle"
    "prow/cmd/tide"
    "prow/cmd/tot"
  ];

  meta = with lib; {
    description = "A Kubernetes based CI/CD system";
    longDescription = ''
      Prow is a Kubernetes based CI/CD system. Jobs can be triggered by various
      types of events and report their status to many different services. In
      addition to job execution, Prow provides GitHub automation in the form of
      policy enforcement, chat-ops via /foo style commands, and automatic PR
      merging.
    '';
    homepage = "https://github.com/kubernetes/test-infra/tree/master/prow";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
