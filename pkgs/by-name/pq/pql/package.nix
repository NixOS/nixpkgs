{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pql";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "runreveal";
    repo = "pql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/112LQfIkya/9hzq3nxtpdSarHIshPw4mezNcKm4xyI=";
  };

  vendorHash = "sha256-hYCbwDChI7pnc9aZ/i2PffTwSBjUjc0Qc71D4EfUOI8=";

  ldflags = [
    "-s"
  ];

  meta = {
    description = "Pipelined Query Language";
    homepage = "https://github.com/runreveal/pql";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "pql";
  };
})
