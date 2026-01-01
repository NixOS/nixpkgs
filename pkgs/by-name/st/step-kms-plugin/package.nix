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
<<<<<<< HEAD
  version = "0.16.0";
=======
  version = "0.15.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "step-kms-plugin";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-q06so1hbiBhQ3TYKEI6C9yO0KctWVMnqGaMJpnWiEag=";
  };

  vendorHash = "sha256-kuKKATZ7GoAy4NU8Zs/zHYdjZ++OTcT9Ep3sunEOpR0=";
=======
    hash = "sha256-Evi5rXdb/2WDlIUXJcQjQ0d1Zrfg1x00tFonlNmLi6E=";
  };

  vendorHash = "sha256-CxX4tQRBPtza1PAVeidp+KNeYxIh5y1tJ+RgcBKdORs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Step plugin to manage keys and certificates on cloud KMSs and HSMs";
    homepage = "https://smallstep.com/cli/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qbit ];
=======
  meta = with lib; {
    description = "Step plugin to manage keys and certificates on cloud KMSs and HSMs";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qbit ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "step-kms-plugin";
  };
}
