{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pql";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "runreveal";
    repo = "pql";
    rev = "v${version}";
    hash = "sha256-/112LQfIkya/9hzq3nxtpdSarHIshPw4mezNcKm4xyI=";
  };

  vendorHash = "sha256-hYCbwDChI7pnc9aZ/i2PffTwSBjUjc0Qc71D4EfUOI8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Pipelined Query Language";
    homepage = "https://github.com/runreveal/pql";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "pql";
  };
}
