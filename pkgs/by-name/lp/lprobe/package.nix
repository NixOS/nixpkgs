{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "lprobe";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "fivexl";
    repo = "lprobe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7wDVITM+1CJzXElmJ1W2E4FO+cYBcmuKCJWU42EvgoI=";
  };

  vendorHash = "sha256-v8U8RrHh7wInpHF7edXif92PYUDE898vYSzb6M05E4Y=";

  buildInputs = [
    libpcap
  ];

  meta = {
    description = "Command-line tool to perform Local Health Check Probes inside Container Images (ECS, Docker)";
    homepage = "https://github.com/fivexl/lprobe";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ cageyv ];
    mainProgram = "lprobe";
  };
})
