{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, IOKit
}:

buildGoModule rec {
  pname = "canarytail";
  version = "0.1.1";
  outputs = [
    "out"
  ];

  src = fetchFromGitHub {
    owner = "canarytail";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WA/jhdCOpEuKKHKXhZyhbYx82iD/F3jHT6SlWKDaQjc=";
  };

  proxyVendor = true;
  vendorHash = "sha256-u3xaiDcFE4Eh1kNClMHI18+j3KW9CkE5W5f9tIe8xtc=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  # prevent `error: 'TARGET_OS_MAC' is not defined`
  env.CGO_CFLAGS = "-Wno-undef-prefix";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $out/bin
  '';

  buildPhase = ''
    go build -o $out/bin/canarytail ./cmd/canarytail.go
  '';

  postInstall = ''
  '';

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
