{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "limesctl";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "sapcc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/9focZIm6tVnkAGIZYTJ9uewXKLv/x74LEMUZbXInb0=";
  };

  vendorHash = "sha256-Zc8X29tsSsM/tkSYvplF1LxBS76eSs+cm5Li3OE/3o8=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "CLI for Limes";
    homepage = "https://github.com/sapcc/limesctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
