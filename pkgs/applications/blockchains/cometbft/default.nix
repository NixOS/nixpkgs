{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cometbft";
  version = "0.38.7";

  src = fetchFromGitHub {
    owner = "cometbft";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YDk9Xcv+R1RoS1KWqlhJoTGs7p3sNxguGmnlP8D5peg=";
  };

  vendorHash = "sha256-Z6Rzc3fMX2F/4jep/u1x/qAkfIKioq9L7jxmlbuFskQ=";

  subPackages = [ "cmd/cometbft" ];

  meta = with lib; {
    description = "Byzantine-Fault Tolerant State Machine Replication. Or Blockchain, for short.";
    homepage = "https://cometbft.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexfmpe jakzale ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
