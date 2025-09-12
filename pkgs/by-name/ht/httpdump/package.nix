{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpcap,
}:

buildGoModule {
  pname = "httpdump";
  version = "0-unstable-2023-05-07";

  src = fetchFromGitHub {
    owner = "hsiafan";
    repo = "httpdump";
    rev = "e971e00e0136d5c770c4fdddb1c2095327d419d8";
    hash = "sha256-3BzvIaZKBr/HHplJe5hM7u8kigmMHxCvkiVXFZopUCQ=";
  };

  vendorHash = "sha256-NKCAzx1+BkqZGeAORl7gCA7f9PSsyKxP2eggZyBB2l8=";

  propagatedBuildInputs = [ libpcap ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Parse and display HTTP traffic from network device or pcap file";
    mainProgram = "httpdump";
    homepage = "https://github.com/hsiafan/httpdump";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
