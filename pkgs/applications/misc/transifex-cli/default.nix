{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "transifex-cli";
  version = "1.6.15";

  src = fetchFromGitHub {
    owner = "transifex";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-NW3vPjXfusBQKDbH8DnU/LMyOP2qkzArD7RYjJ1IQvM=";
  };

  vendorHash = "sha256-3gi2ysIb5256CdmtX38oIfeDwNCQojK+YB9aEm8H01Q=";

  ldflags = [
    "-s" "-w" "-X 'github.com/transifex/cli/internal/txlib.Version=${version}'"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/tx
  '';

  # Tests contain network calls
  doCheck = false;

  meta = with lib; {
    description = "Transifex command-line client";
    homepage = "https://github.com/transifex/transifex-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ thornycrackers ];
    mainProgram = "tx";
  };
}
