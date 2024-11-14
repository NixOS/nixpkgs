{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotest";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v11ccrjghq7nsz0f91r17di14yixsw28vs0m3dwzwqkh1a20img";
  };

  vendorHash = "sha256-pVq6H1HoKqCMRfJg7FftRf3vh+BWZQe6cQAX+TBzKqw=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "go test with colors";
    mainProgram = "gotest";
    homepage = "https://github.com/rakyll/gotest";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
