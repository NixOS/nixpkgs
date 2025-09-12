{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-entgrpc";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ent";
    repo = "contrib";
    rev = "v${version}";
    sha256 = "sha256-kI+/qbWvOxcHKee7jEFBs5Bb+5MPGunAsB6d1j9fhp8=";
  };

  vendorHash = "sha256-tOt6Uxo4Z2zJrTjyTPoqHGfUgxFmtB+xP+kB+S6ez84=";

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
