{
  lib,
  stdenv,
  libpcap,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "spoofdpi";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5NBOsklCAGDRPSdkglCDgkXQp2aeo2g0EcqecsLJT6o=";
  };

  vendorHash = "sha256-WqIAE5j3pqyGg5fdA75h9r40QB/lLQO7lgJyI3P7Jgk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.build=nixpkgs"
  ];

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    mainProgram = "${finalAttrs.pname}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
})
