{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "adif-multitool";
  version = "0.1.12-rc1";

  vendorHash = "sha256-h7Gr8qRz6K0xCvR8tGWTeEkwgMQOTZnbEEsda4aJpbc=";

  src = fetchFromGitHub {
    owner = "flwyd";
    repo = "adif-multitool";
    rev = "v${version}";
    hash = "sha256-R0Hu/yWiLUpH9qkVQuJw4bRvDeISjg67rZJLeUBPBbM=";
  };

  meta = with lib; {
    description = "Command-line program for working with ham logfiles.";
    homepage = "https://github.com/flwyd/adif-multitool";
    license = licenses.asl20;
    maintainers = with maintainers; [ mafo ];
    mainProgram = "adifmt";
  };
}
