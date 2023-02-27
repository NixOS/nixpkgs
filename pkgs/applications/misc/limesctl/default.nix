{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fi36jsQr/Mn1FyOlle/WSpREQgZU6+h4IJzd3ZfItvI=";
  };

  vendorSha256 = "sha256-gcIPASIk4Zq8y+KppYNRkf/9guCsYv9XskFANrqOCts=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
