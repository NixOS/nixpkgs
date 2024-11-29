{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mev-boost";
  version = "1.8";
  src = fetchFromGitHub {
      owner = "flashbots";
      repo = "mev-boost";
      rev = "v${version}";
      hash = "sha256-EFPVBSSIef3cTrYp3X1xCEOtYcGpuW/GZXHXX+0wGd8=";
  };

  vendorHash = "sha256-xkncfaqNfgPt5LEQ3JyYXHHq6slOUchomzqwkZCgCOM=";

  meta = with lib; {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with maintainers; [ ekimber ];
    platforms = platforms.unix;
  };
}
