{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  pcsclite,
  softhsm,
  opensc,
  yubihsm-shell,
}:

buildGoModule rec {
  pname = "step-kms-plugin";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "step-kms-plugin";
    rev = "v${version}";
    hash = "sha256-c9QRyrohktS/ZjG6DOeNXaFRiqxDCdst00m0xjcg9SQ=";
  };

  vendorHash = "sha256-5bnYtj4Dda3PiU9NAP32tOC6hZxwIbAynNZuAmMOs+A=";

  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    opensc
    pcsclite
    softhsm
    yubihsm-shell
  ];

  ldflags = [
    "-w"
    "-s"
    "-X github.com/smallstep/step-kms-plugin/cmd.Version=${version}"
  ];

  env.CGO_CFLAGS = "-I${lib.getDev pcsclite}/include/PCSC/";

  meta = {
    description = "Step plugin to manage keys and certificates on cloud KMSs and HSMs";
    homepage = "https://smallstep.com/cli/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "step-kms-plugin";
  };
}
