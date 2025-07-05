{ buildGoModule, fetchFromGitHub, lib }:
buildGoModule rec {
  pname = "grpcwebproxy";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "improbable-eng";
    repo = "grpc-web";
    rev = "v${version}";
    sha256 = "sha256-oWquyiEUV9dsdT7GrfCztw/Dp5FOTS7nQSSQ8xGw4tk=";
  };

  subPackages = [ "go/grpcwebproxy" ];
  vendorHash = "sha256-8KRjugc+Bde0HqjzpY0Ib/JbsoIwEwJTKmk/EvHnaME=";

  meta = with lib; {
    description = "A small reverse proxy that can front existing gRPC servers and expose their functionality using gRPC-Web protocol";
    homepage = "https://github.com/improbable-eng/grpc-web";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bouk ];
    mainProgram = "grpcwebproxy";
  };
}
