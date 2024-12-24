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
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-68BO4bTieh7nC8M821vbTP8SuFipLRwHOWdWvhCwoCo=";
  };

  vendorHash = "sha256-HOB4ODVD8lWHoejqykfRWx3g48ijMqgy9EPzCKYdIGg=";

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
