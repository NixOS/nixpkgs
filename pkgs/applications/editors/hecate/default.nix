{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hecate";
  version = "unstable-2022-05-23";

  src = fetchFromGitHub {
    owner = "evanmiller";
    repo = "hecate";
    rev = "7637250f4b2c5b777418b35fa11276d11d5128b0";
    sha256 = "sha256-8L0ukzPF7aECCeZfwZYKcJAJLpPgotkVJ+OSdwQUjhw=";
  };

  vendorSha256 = "sha256-eyMrTrNarNCB3w8EOeJBmCbVxpMZy25sQ19icVARU1M=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/evanmiller/hecate";
    description = "terminal hex editor";
    longDescription = "The Hex Editor From Hell!";
    license = licenses.mit;
    maintainers = with maintainers; [ ramkromberg ];
  };
}
