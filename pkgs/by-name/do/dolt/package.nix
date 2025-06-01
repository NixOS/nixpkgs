{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule rec {
  pname = "dolt";
  version = "1.53.6";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-T/o4Fdfyq5kK4wG11Gdfa66iHv2Zb58v1geebFk/Ouc=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-irMXQGOsTP/zSyVAYOtWex/H1cdNSthuyPbbR5FwCNI=";
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
