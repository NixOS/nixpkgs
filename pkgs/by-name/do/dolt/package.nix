{ fetchFromGitHub, lib, buildGoModule }:

buildGoModule rec {
  pname = "dolt";
  version = "1.50.5";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-dVBE2j+vr2BUBpXSFy9iM4hd6Q032J0v9UFEh+QRV/c=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-5875DFFoR0Xq+5aORLpHklt+L53PbeoCVom/1LEmGpo=";
  proxyVendor = true;
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
