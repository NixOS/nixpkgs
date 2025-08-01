{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  systemd,
}:

buildGoModule rec {
  pname = "node-problem-detector";
  version = "0.8.21";

  src = fetchFromGitHub {
    owner = "kubernetes";
    repo = "node-problem-detector";
    rev = "v${version}";
    sha256 = "sha256-byxj6EXKAmesFOBtBt0URcT0h1pYdrW8ewtITuEPFcs=";
  };

  vendorHash = null;

  doCheck = false;

  # Optionally, a log counter binary can be created to parse journald logs.
  # The binary is dynamically linked against systemd libraries, making it a
  # Linux-only feature. See 'ENABLE_JOURNALD' upstream:
  # https://github.com/kubernetes/node-problem-detector/blob/master/Makefile
  subPackages = [
    "cmd/nodeproblemdetector"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ "cmd/logcounter" ];

  preBuild = ''
    export CGO_ENABLED=${if stdenv.hostPlatform.isLinux then "1" else "0"}
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ systemd ];

  tags = lib.optionals stdenv.hostPlatform.isLinux [ "journald" ];

  ldflags = [
    "-X k8s.io/node-problem-detector/pkg/version.version=v${version}"
  ];

  meta = {
    description = "Various problem detectors running on the Kubernetes nodes";
    homepage = "https://github.com/kubernetes/node-problem-detector";
    changelog = "https://github.com/kubernetes/node-problem-detector/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lbpdt ];
  };
}
