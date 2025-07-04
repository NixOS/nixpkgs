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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "step-kms-plugin";
    rev = "v${version}";
    hash = "sha256-XZRNEUMko3HMlKOyHYK3TQywkqC6K5VvdvGFTSk6V68=";
  };

  vendorHash = "sha256-gIzllbLAshJXoTawTbQ+ERliaHwhJhQM6v1aykDKF7M=";

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
