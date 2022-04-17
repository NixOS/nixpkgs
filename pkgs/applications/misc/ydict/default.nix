{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "ydict";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "ydict";
    rev = "v${version}";
    sha256 = "sha256-zhjsXZsRk0UNijjqjGjZh4TiPxAM5p+ic3JMx2wrPeY=";
  };

  vendorSha256 = "sha256-O6czDfKD18rGVMIZv6II09oQu1w0ijQRuZRGt2gj9Cs=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "A command-line Chinese dictionary";
    homepage = "https://github.com/TimothyYe/ydict";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
