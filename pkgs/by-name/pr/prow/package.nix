{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule rec {
  pname = "prow";
  version = "0-unstable-2024-08-27";
  rev = "195f38540f39dd3ec95ca2d7086487ec19922e61";

  src = fetchFromGitHub {
    inherit rev;

    owner = "kubernetes-sigs";
    repo = "prow";
    hash = "sha256-/OhlJdxPa4rTuT7XIklx8vxprbENfasJYwiJxD4CeXY=";
  };

  vendorHash = "sha256-bJ0P/rHp+0zB/Dtp3F3n4AN3xF/A5qoq3lCQVBK+L4w=";

  # doCheck = false;

  subPackages = [
    "cmd/admission"
    "cmd/branchprotector"
    "cmd/checkconfig"
    "cmd/clonerefs"
    "cmd/cm2kc"
    "cmd/config-bootstrapper"
    "cmd/crier"
    "cmd/deck"
    "cmd/entrypoint"
    "cmd/exporter"
    "cmd/external-plugins"
    "cmd/gangway"
    "cmd/gcsupload"
    "cmd/generic-autobumper"
    "cmd/gerrit"
    "cmd/ghproxy"
    "cmd/hmac"
    "cmd/hook"
    "cmd/horologium"
    "cmd/initupload"
    "cmd/invitations-accepter"
    "cmd/jenkins-operator"
    "cmd/mkpj"
    "cmd/mkpod"
    "cmd/moonraker"
    "cmd/peribolos"
    "cmd/phony"
    "cmd/pipeline"
    "cmd/prow-controller-manager"
    "cmd/sidecar"
    "cmd/sinker"
    "cmd/status-reconciler"
    "cmd/sub"
    "cmd/tackle"
    "cmd/tide"
    "cmd/tot"
    "cmd/webhook-server"
  ];

  nativeCheckInputs = [ git ];

  meta = {
    description = "Kubernetes based CI/CD system developed to serve the Kubernetes community";
    longDescription = ''
      Prow is a Kubernetes based CI/CD system. Jobs can be triggered by various
      types of events and report their status to many different services. In
      addition to job execution, Prow provides GitHub automation in the form of
      policy enforcement, chat-ops via /foo style commands, and automatic PR
      merging.
    '';
    homepage = "https://github.com/kubernetes-sigs/prow";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kalbasit ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
