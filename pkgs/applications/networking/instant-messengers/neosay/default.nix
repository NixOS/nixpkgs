{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "neosay";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "donuts-are-good";
    repo = "neosay";
    rev = "v${version}";
    hash = "sha256-2tFjvAobDpBh1h0ejdtqxDsC+AqyneN+xNssOJNfEbk=";
  };

  vendorHash = "sha256-w0aZnel5Obq73UXcG9wmO9t/7qQTE8ru656u349cvzQ=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Pipe stdin to matrix";
    mainProgram = "neosay";
    homepage = "https://github.com/donuts-are-good/neosay";
    license = licenses.mit;
    maintainers = [ ];
  };
}
