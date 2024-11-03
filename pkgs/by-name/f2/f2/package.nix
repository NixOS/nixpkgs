{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "f2";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
    sha256 = "sha256-njxjXdedhKK7bn9XmQte6CrEiZlHQ+4C2lulrqmwaKQ=";
  };

  vendorHash = "sha256-BtumgNz21AcUdeL2PBPCDIAfMZdz+IiSUBf4t3rDZ/s=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
    mainProgram = "f2";
  };
}
