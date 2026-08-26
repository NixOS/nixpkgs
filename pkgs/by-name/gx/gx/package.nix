{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gx";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "whyrusleeping";
    repo = "gx";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-jGtUsb2gm8dN45wniD+PYoUlk8m1ssrfj1a7PPYEYuo=";
  };

  vendorHash = "sha256-6tdVpMztaBjoQRVG2vaUWuvnPq05zjbNAX9HBiC50t0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Packaging tool built around IPFS";
    homepage = "https://github.com/whyrusleeping/gx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "gx";
  };
})
