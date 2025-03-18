{ lib, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles, testers, rosa, nix-update-script }:

buildGoModule rec {
  pname = "rosa";
  version = "1.2.43";

  src = fetchFromGitHub {
    owner = "openshift";
    repo = "rosa";
    rev = "v${version}";
    hash = "sha256-1/go7mL2uRzzV/iiTXsgZHGNW8EIONwEnb4jcMiKkv4=";
  };
  vendorHash = null;

  patches = [
    # https://github.com/openshift/rosa/pull/2326/
    # TODO: remove on next version bump
    (fetchpatch {
      url = "https://github.com/openshift/rosa/commit/9ed236880f91f0e9514ba0a6f3be93ee115d1689.patch";
      hash = "sha256-KNGqJRFyfzcDs336Lj/KwR1yd5M7zfehu7IO0z/KUtg=";
    })
  ];

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
