{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  xorg,
}:

buildGoModule rec {
  pname = "gapcast";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "ANDRVV";
    repo = "gapcast";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ei5XfcnbUoegB8lNEEQ3PrCzNJGaVeVd2lfrMWYoODw=";
  };

  vendorHash = "sha256-jn0zTorp/rkd91+ZGDbsNVcTxEndFMMrsb+/dGrZcy4=";

  buildInputs = [
    libpcap
    xorg.libX11
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "802.11 broadcast analyzer & injector";
    homepage = "https://github.com/ANDRVV/gapcast";
    changelog = "https://github.com/ANDRVV/gapcast/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gapcast";
    broken = stdenv.isDarwin;
  };
}
