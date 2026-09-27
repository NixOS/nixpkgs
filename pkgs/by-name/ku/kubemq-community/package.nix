{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "kubemq-community";
  version = "2.3.7";
  src = fetchFromGitHub {
    owner = "kubemq-io";
    repo = "kubemq-community";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-oAo/O3T3wtfCumT2kjoyXKfCFHijVzSmxhslaKaeF3Y=";
  };

  env.CGO_ENABLED = 0;

  ldflags = [
    "-w"
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = false; # grpc tests are flaky

  vendorHash = "sha256-L1BxxSI2t0qWXizge+X3BrpGPaSy5Dk81vKuI0N5Ywg=";

  meta = {
    homepage = "https://github.com/kubemq-io/kubemq-community";
    description = "KubeMQ Community is the open-source version of KubeMQ, the Kubernetes native message broker";
    mainProgram = "kubemq-community";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brianmcgee ];
  };
})
