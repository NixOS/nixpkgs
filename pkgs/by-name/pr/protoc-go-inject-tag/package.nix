{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "protoc-go-inject-tag";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "favadi";
    repo = "protoc-go-inject-tag";
    rev = "v${version}";
    hash = "sha256-8mpkwv80PMfOPiammg596hW7xdrcum9Hl/v5O1DPWgY=";
  };

  vendorHash = "sha256-tMpcJ37yGr7i91Kwz57FmJ+u2x0CAus0+yWOR10fJLo=";

  meta = with lib; {
    description = "Inject custom tags to protobuf golang struct";
    homepage = "https://github.com/favadi/protoc-go-inject-tag/tree/v1.4.0";
    license = licenses.bsd2;
    maintainers = with maintainers; [ elrohirgt ];
    mainProgram = "protoc-go-inject-tag";
  };
}
