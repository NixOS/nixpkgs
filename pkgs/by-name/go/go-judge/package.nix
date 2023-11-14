{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-judge";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "criyle";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iKSOD/jh7NgGUNeQxFqlZDcctUXBDC1Tjxsm0Q2iZ3I=";
  };

  vendorHash = "sha256-GVsRflqqt+PwVGWaNGMH4prKQ5pWqPRlsTBJZtC+7zo=";

  tags = [ "nomsgpack" ];

  subPackages = [ "cmd/go-judge" ];

  preBuild = ''
    echo v${version} > ./cmd/go-judge/version/version.txt
  '';

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "High performance sandbox service based on container technologies";
    homepage = "https://github.com/criyle/go-judge";
    license = licenses.mit;
    mainProgram = "go-judge";
    maintainers = with maintainers; [ criyle ];
  };
}
