{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "faraday";
  version = "0.2.3-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "faraday";
    rev = "v${version}";
    sha256 = "16cqaslsbwda23b5n0sfppybd3ma4ch545100ydxrwac4zhrq4kq";
  };

  vendorSha256 = "1hh99nfprlmhkc36arg3w1kxby59i2l7n258cp40niv7bjn37hrq";

  subPackages = [ "cmd/frcli" "cmd/faraday" ];

  meta = with lib; {
    description = "LND Channel Management Tools";
    homepage = "https://github.com/lightninglabs/faraday";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags ];
  };
}
