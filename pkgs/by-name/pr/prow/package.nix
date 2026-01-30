{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
}:

buildGoModule rec {
  pname = "prow";
  version = "0-unstable-2026-01-26";
  rev = "a0e74f2f7661a5ce8ecae738314ec0b4d4a182b0";

  src = fetchFromGitHub {
    inherit rev;

    owner = "kubernetes-sigs";
    repo = "prow";
    hash = "sha256-EKWd0G6ONOWNYZCyp4UlY4lalfhB27sV5HwkKmyRscs=";
  };

  vendorHash = "sha256-Pv9LznRh7Nzm74gMKT2Q/VLIMIIc93en0qX6YA6TwK4=";

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

  nativeCheckInputs = [ gitMinimal ];

  # Workaround for: panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  # ref: https://github.com/NixOS/nix/pull/1646
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

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
