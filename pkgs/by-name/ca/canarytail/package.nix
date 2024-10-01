{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, fetchpatch2
, installShellFiles
, go
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
  ];

  proxyVendor = true;
  vendorHash = "sha256-5oxCi0A3yatnVdV1Nx7KBUgPbvB41VmjMgiqLpNl+oI=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $out/bin
  '';

  buildPhase = ''
    go build -o $out/bin/canarytail ./cmd/canarytail.go
  '';

  passthru.tests.canarytail-tests = stdenv.mkDerivation {
    name = "canarytail-client-tests";
    buildInputs = [ go ];

    src = fetchFromGitHub {
      owner = "ScreamingHawk";
      repo = "canary-client";
      rev = "0871ad14489c0b96d5cd3d980fb0028f8026f2ee";
      hash = "sha256-FfU9drEE+xFjZpNddQqt53gvhSpiEs5QTVC7XR1kVP8=";
    };

    preCheck = ''
      export HOME=$(mktemp -d)
    '';

    installPhase = ''
      # No need to install anything, we only need to run the tests
    '';

    checkPhase = ''
      go mod vendor
      go test -mod=vendor ./blockchain_test.go ./canary_test.go ./crypto_test.go
    '';
  };

  doCheck = false;

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
