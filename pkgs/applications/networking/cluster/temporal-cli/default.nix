{ lib, fetchFromGitHub, buildGoModule, installShellFiles, symlinkJoin, stdenv }:

let
  metaCommon = with lib; {
    description = "Command-line interface for running Temporal Server and interacting with Workflows, Activities, Namespaces, and other parts of Temporal";
    homepage = "https://docs.temporal.io/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };

  overrideModAttrs = old: {
    # https://gitlab.com/cznic/libc/-/merge_requests/10
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

  tctl-next = buildGoModule rec {
    pname = "tctl-next";
    version = "0.13.0";

    src = fetchFromGitHub {
      owner = "temporalio";
      repo = "cli";
      rev = "v${version}";
      hash = "sha256-2zk+B+GomLZwep5LNRpWJj8JjFC0OxAl1XhAv+8b2kc=";
    };

    vendorHash = "sha256-NLteuVOswIw2ModdE0Ak4XmApkHLoYDt6SDAZGsgwBk=";

    inherit overrideModAttrs;

    nativeBuildInputs = [ installShellFiles ];

    excludedPackages = [ "./cmd/docgen" "./tests" ];

    ldflags = [
      "-s"
      "-w"
      "-X github.com/temporalio/cli/headers.Version=${version}"
    ];

    # Tests fail with x86 on macOS Rosetta 2
    doCheck = !(stdenv.isDarwin && stdenv.hostPlatform.isx86_64);

    preCheck = ''
      export HOME="$(mktemp -d)"
    '';

    postInstall = ''
      installShellCompletion --cmd temporal \
        --bash <($out/bin/temporal completion bash) \
        --fish <($out/bin/temporal completion fish) \
        --zsh <($out/bin/temporal completion zsh)
    '';

    __darwinAllowLocalNetworking = true;

    meta = metaCommon // {
      mainProgram = "temporal";
    };
  };

  tctl = buildGoModule rec {
    pname = "tctl";
    version = "1.18.1";

    src = fetchFromGitHub {
      owner = "temporalio";
      repo = "tctl";
      rev = "v${version}";
      hash = "sha256-LX4hyPme+mkNmPvrTHIT5Ow3QM8BTAB7MXSY1fa8tSk=";
    };

    vendorHash = "sha256-294lnUKnXNrN6fJ+98ub7LwsJ9aT+FzWCB3nryfAlCI=";

    inherit overrideModAttrs;

    nativeBuildInputs = [ installShellFiles ];

    excludedPackages = [ "./cmd/copyright" ];

    ldflags = [ "-s" "-w" ];

    preCheck = ''
      export HOME="$(mktemp -d)"
    '';

    postInstall = ''
      installShellCompletion --cmd tctl \
        --bash <($out/bin/tctl completion bash) \
        --zsh <($out/bin/tctl completion zsh)
    '';

    __darwinAllowLocalNetworking = true;

    meta = metaCommon // {
      mainProgram = "tctl";
    };
  };
in
symlinkJoin rec {
  pname = "temporal-cli";
  inherit (tctl) version;
  name = "${pname}-${version}";

  paths = [
    tctl-next
    tctl
  ];

  passthru = { inherit tctl tctl-next; };

  meta = metaCommon // {
    mainProgram = "temporal";
    platforms = lib.unique (lib.concatMap (drv: drv.meta.platforms) paths);
  };
}
