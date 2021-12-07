{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    sha256 = "01brxckjz8vlgaq9917l45xf48078d4465qn9l0lyll6hic6p06c";
  };

  vendorSha256 = "0mvx4rzs0mvb1dyxj105mh2awfy0bmp716x7hpfdwhwz3p11fc7k";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
