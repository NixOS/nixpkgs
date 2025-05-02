{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "protoc-go-inject-tag";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "favadi";
    repo = "protoc-go-inject-tag";
    rev = "v${version}";
    sha256 = "01jsrx83pygvjx3nzfnwvb2vn5gagl79m9i67v7cfg1lzz168spj";
  };

  vendorHash = "sha256-tMpcJ37yGr7i91Kwz57FmJ+u2x0CAus0+yWOR10fJLo=";

  meta = with lib; {
    description = "Inject custom tags to protobuf golang struct";
    homepage = "https://github.com/favadi/protoc-go-inject-tag/tree/v1.4.0";
    license = licenses.bsd2;
    maintainers = with maintainers; [elrohirgt];
    mainProgram = "protoc-go-inject-tag";
  };
}
