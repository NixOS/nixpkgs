{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, rosa, nix-update-script }:

buildGoModule rec {
  pname = "rosa";
  version = "1.2.39";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "rosa";
    rev = "v${version}";
    hash = "sha256-K1FGiUNXSyCTmF//dculpnkTyn3hfqWrOiMUGk9kHrA=";
  };
  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    # e2e tests require network access
    rm -r tests/e2e
  '';

  preCheck = ''
    # Workaround for cmd/list/rhRegion/cmd_test.go:39
    #   Failed to get OCM regions: Can't retrieve shards: Get "https://api.stage.openshift.com/static/ocm-shards.json": dial tcp: lookup api.stage.openshift.com on [::1]:53: read udp [::1]:55793->[::1]:53: read: connection refused
    substituteInPlace "cmd/list/rhRegion/cmd_test.go" \
      --replace-fail "TestRhRegionCommand" "SkipRhRegionCommand"
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd rosa \
      --bash <($out/bin/rosa completion bash) \
      --fish <($out/bin/rosa completion fish) \
      --zsh <($out/bin/rosa completion zsh)
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = rosa;
      command = "rosa version --client";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Service on AWS";
    license = licenses.asl20;
    homepage = "https://github.com/openshift/rosa";
    maintainers = with maintainers; [ jfchevrette ];
  };
}
