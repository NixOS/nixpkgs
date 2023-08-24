{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "kusk";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "kubeshop";
    repo = "kusk-gateway";
    rev = "v${version}";
    hash = "sha256-6P7xY3NJJdH+84b18aOgpVYFO9maYd57NWF3+wYogYo=";
  };

  vendorHash = "sha256-2KCx/u4vNlhuPwZUUlJWI1z2/iLVghpdWuWWPDTGoiA=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Kusk-gateway is an OpenAPI-driven API Gateway for Kubernetes";
    homepage = "https://github.com/kubeshop/kusk-gateway";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "kusk";
  };
}
