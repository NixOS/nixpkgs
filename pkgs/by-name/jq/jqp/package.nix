{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i22qALVa8EUaTwgN6DocGJArNyOvkQbFuH++EQKBuIc=";
  };

  vendorHash = "sha256-GbY0x4BgV0+QdVMkITLF/W//oO72FbjV6lNJRm6ecys=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "TUI playground to experiment with jq";
    mainProgram = "jqp";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
