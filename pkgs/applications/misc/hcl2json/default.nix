{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lnmWIyS1byXvShR1/ej8PAuo+WJBEBykQwJ79439Fus=";
  };

  vendorHash = "sha256-HbdectUQgyQZ9qcfBarwRTF3VjzSqaM2vhVekThv2+k=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
    mainProgram = "hcl2json";
  };
}
