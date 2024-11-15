{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule rec {
  pname = "dolt";
  version = "1.43.14";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-ocQtbYdpqKoumG5WEE4q4WiQPgT2ezCVu11DvfG+vXo=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-ruGyOI+RmVxTe321a5APkKcQzLbOSw05q4zqQ9Fe1MY=";
  proxyVendor = true;
  doCheck = false;

  meta = {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danbst ];
  };
}
