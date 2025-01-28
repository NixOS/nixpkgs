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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zYDKUSYnuYGexWet8F6DI/5nPcGJtvSvB7b6sij6JY8=";
  };

  vendorHash = "sha256-sXwaxMfBb8zZDCP3g8iZgXL540uDyWtu57cUPia9FzA=";

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

  meta = with lib; {
    description = "step plugin to manage keys and certificates on cloud KMSs and HSMs";
    homepage = "https://smallstep.com/cli/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qbit ];
    mainProgram = "step-kms-plugin";
    # can't find pcsclite header files
    broken = stdenv.hostPlatform.isDarwin;
  };
}
