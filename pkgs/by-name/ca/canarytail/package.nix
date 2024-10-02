{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  installShellFiles,
  go,
}:

buildGoModule rec {
  pname = "canarytail";
  version = "0.1.2+unstable-latest";
  outputs = [
    "out"
  ];

  src = fetchFromGitHub {
    owner = "canarytail";
    repo = "client";
    rev = "3e585105ab155e4a5229a9dd8664a0aff60deb7c";
    hash = "sha256-WQJvOg1Ax3zujIRVMweYrI8tpGX4PB7nmUzXZNe3V0U=";
  };

  patches = [
    # Update go mod crypto
    # https://github.com/canarytail/client/pull/22
    (fetchpatch2 {
      url = "https://github.com/canarytail/client/commit/0871ad14489c0b96d5cd3d980fb0028f8026f2ee.patch?full_index=1";
      hash = "sha256-uO4bSUTD3iBmZHGvhwFuOQDjFUElYSuIGICHvh+62eY=";
    })
    # Builds on pull request 22, ensuring tests pass
    # https://github.com/jee-mj/canary-client
    (fetchpatch2 {
      url = "https://github.com/canarytail/client/commit/20eb1da6e10e9acbefbb74f3f2170ce72514a239.patch?full_index=1";
      hash = "sha256-IaMwLiknCpNGO9el5qZvdcg8DQvIuajKDXvtMj8Qt6c=";
    })
  ];

  proxyVendor = true;
  vendorHash = "sha256-5oxCi0A3yatnVdV1Nx7KBUgPbvB41VmjMgiqLpNl+oI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $out/bin
  '';

  buildPhase = ''
    go build -o $out/bin/canarytail ./cmd/canarytail.go
  '';

  passthru.tests.canarytail-tests = buildGoModule {
    pname = "canarytail-client-tests";
    version = "0.1.2+unstable-latest";

    src = fetchFromGitHub {
      owner = "canarytail";
      repo = "client";
      rev = "20eb1da6e10e9acbefbb74f3f2170ce72514a239";
      hash = "sha256-UZDxtMtKTS2l6WMdBd03mrvfpBHFziyF6lHGYP33XYQ=";
    };

    proxyVendor = true;
    vendorHash = "sha256-5oxCi0A3yatnVdV1Nx7KBUgPbvB41VmjMgiqLpNl+oI=";

    checkPhase = ''
      # Use vendored dependencies for tests as well
      go test ./canary_test.go ./crypto_test.go # ./blockchain_test.go
      # blockchain_test fails due to sandboxing, but has been tested locally using command:
      # `nix-build --option sandbox false -A passthru.tests.canarytail-tests`
    '';
  };

  doCheck = true;

  meta = with lib; {
    description = "Official CanaryTail implementation in Golang for easy, trackable, standardized warrant canaries.";
    longDescription = ''
      CanaryTail CLI is a simple proof-of-concept implementation of the CanaryTail standard
    '';
    homepage = "https://github.com/canarytail/client";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.mj ];
    mainProgram = "canarytail";
  };
}
