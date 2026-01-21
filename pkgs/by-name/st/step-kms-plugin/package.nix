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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "step-kms-plugin";
    rev = "v${version}";
    hash = "sha256-q06so1hbiBhQ3TYKEI6C9yO0KctWVMnqGaMJpnWiEag=";
  };

  vendorHash = "sha256-kuKKATZ7GoAy4NU8Zs/zHYdjZ++OTcT9Ep3sunEOpR0=";

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

  CGO_CFLAGS = "-I${lib.getDev pcsclite}/include/PCSC/";

  meta = {
    description = "Step plugin to manage keys and certificates on cloud KMSs and HSMs";
    homepage = "https://smallstep.com/cli/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qbit ];
    mainProgram = "step-kms-plugin";
  };
}
