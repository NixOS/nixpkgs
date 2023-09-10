{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hcl2json";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XdPRata9B8cK58eyAKxEBBwKAum+z0yoGgUGSkmhXfw=";
  };

  vendorHash = "sha256-F7G8K0tfXyLHQgqd2PE9eRXlhkFgijAO9LKKj9mvvwc=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert hcl2 to json";
    homepage = "https://github.com/tmccombs/hcl2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
