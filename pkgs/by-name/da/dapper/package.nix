{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dapper";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = "dapper";
    rev = "v${version}";
    sha256 = "sha256-V+lHnOmIWjI1qmoJ7+pp+cGmJAtSeY+r2I9zykswQzM=";
  };
  vendorHash = null;

  patchPhase = ''
    substituteInPlace main.go --replace 0.0.0 ${version}
  '';

  meta = with lib; {
    description = "Docker build wrapper";
    mainProgram = "dapper";
    homepage = "https://github.com/rancher/dapper";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kuznero ];
  };
}
