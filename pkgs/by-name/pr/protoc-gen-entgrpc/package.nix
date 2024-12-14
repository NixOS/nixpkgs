{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-8BQXjoVTasCReAc3XWBgeoYmL9zLj+uvf9TRKBYaAr4=";
  };

  vendorHash = "sha256-jdjcnDfEAP33oQSn5nqgFqE+uwKBXp3gJWTNiiH/6iw=";

  subPackages = [ "entproto/cmd/protoc-gen-entgrpc" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Generator of an implementation of the service interface for ent protobuff";
    mainProgram = "protoc-gen-entgrpc";
    downloadPage = "https://github.com/ent/contrib/";
    license = licenses.asl20;
    homepage = "https://entgo.io/";
    maintainers = [ ];
  };
}
