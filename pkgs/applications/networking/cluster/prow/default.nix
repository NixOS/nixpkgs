{ buildGoModule, fetchFromGitHub, stdenv, Security }:

buildGoModule rec {
  pname = "prow-unstable";
  version = "2019-08-14";
  rev = "35a7744f5737bbc1c4e1256a9c9c5ad135c650e4";

  src = fetchFromGitHub {
    inherit rev;

    owner = "kubernetes";
    repo = "test-infra";
    sha256 = "07kdlzrj59xyaa73vlx4s50fpg0brrkb0h0cyjgx81a0hsc7s03k";
  };

  patches = [
    # https://github.com/kubernetes/test-infra/pull/13918
    ./13918-fix-go-sum.patch
  ];

  modSha256 = "06q1zvhm78k64aj475k1xl38h7nk83mysd0bja0wknja048ymgsq";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  subPackages = [
    "./prow/cmd/admission"
    "./prow/cmd/artifact-uploader"
    "./prow/cmd/branchprotector"
    "./prow/cmd/build"
    "./prow/cmd/checkconfig"
    "./prow/cmd/clonerefs"
    "./prow/cmd/config-bootstrapper"
    "./prow/cmd/crier"
    "./prow/cmd/deck"
    "./prow/cmd/entrypoint"
    "./prow/cmd/gcsupload"
    "./prow/cmd/gerrit"
    "./prow/cmd/hook"
    "./prow/cmd/horologium"
    "./prow/cmd/initupload"
    "./prow/cmd/jenkins-operator"
    "./prow/cmd/mkbuild-cluster"
    "./prow/cmd/mkpj"
    "./prow/cmd/mkpod"
    "./prow/cmd/peribolos"
    "./prow/cmd/phaino"
    "./prow/cmd/phony"
    "./prow/cmd/pipeline"
    "./prow/cmd/plank"
    "./prow/cmd/sidecar"
    "./prow/cmd/sinker"
    "./prow/cmd/status-reconciler"
    "./prow/cmd/sub"
    "./prow/cmd/tackle"
    "./prow/cmd/tide"
    "./prow/cmd/tot"
  ];

  meta = with stdenv.lib; {
    description = "Prow is a Kubernetes based CI/CD system";
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
