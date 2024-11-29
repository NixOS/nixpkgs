{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "thrift-ls";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "joyme123";
    repo = "thrift-ls";
    rev = "v${version}";
    hash = "sha256-hZpzez3xNnN76OcIzEswPbvw6QTU51Jnrry3AWCtbFk=";
  };

  vendorHash = "sha256-YoZ2dku84065Ygh9XU6dOwmCkuwX0r8a0Oo8c1HPsS4=";

  postInstall = ''
    mv $out/bin/thrift-ls $out/bin/thriftls
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Thrift Language Server";
    homepage = "https://github.com/joyme123/thrift-ls";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      callumio
      hughmandalidis
    ];
    mainProgram = "thriftls";
  };
}
