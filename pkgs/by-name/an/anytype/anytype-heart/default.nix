{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  buildGoModule,
  protoc-gen-grpc-web,
  protoc-gen-js,
  protobuf,
}:

let
  tantivy-go = callPackage ../tantivy-go { };
  pname = "anytype-heart";
  version = "0.39.11";
  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-heart";
    tag = "v${version}";
    hash = "sha256-+H63bc4aJPERfclzKh4E3uYEEwNycLfe0BCPSlilqCc=";
  };

  arch =
    {
      # https://github.com/anyproto/anytype-heart/blob/f33a6b09e9e4e597f8ddf845fc4d6fe2ef335622/pkg/lib/localstore/ftsearch/ftsearchtantivy.go#L3
      x86_64-linux = "linux-amd64-musl";
      aarch64-linux = "linux-arm64-musl";
      x86_64-darwin = "darwin-amd64";
      aarch64-darwin = "darwin-arm64";
    }
    .${stdenv.hostPlatform.system};
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-fbZ1DiRcD9dnS8e7BMrKPYApqZmQbaH6DsSSO1knDmo=";

  subPackages = [ "cmd/grpcserver" ];
  tags = [
    "nosigar"
    "nowatchdog"
  ];

  env.CGO_ENABLED = 1;
  proxyVendor = true;

  nativeBuildInputs = [
    protoc-gen-grpc-web
    protoc-gen-js
    protobuf
  ];

  preBuild = ''
    mkdir -p deps/libs/${arch}
    cp ${tantivy-go}/lib/libtantivy_go.a deps/libs/${arch}
  '';

  postBuild = ''
    protoc -I ./  --js_out=import_style=commonjs,binary:./dist/js/pb pb/protos/service/*.proto pb/protos/*.proto pkg/lib/pb/model/protos/*.proto
    protoc -I ./  --grpc-web_out=import_style=commonjs+dts,mode=grpcwebtext:./dist/js/pb pb/protos/service/*.proto pb/protos/*.proto pkg/lib/pb/model/protos/*.proto
  '';

  postInstall = ''
    mv $out/bin/grpcserver $out/bin/anytypeHelper
    mkdir -p $out/lib
    cp -r dist/js/pb/* $out/lib
    cp -r dist/js/pb/* $out/lib

    mkdir -p $out/lib/json/generated
    cp pkg/lib/bundle/system*.json $out/lib/json/generated
    cp pkg/lib/bundle/internal*.json $out/lib/json/generated

    mkdir -p $out/share
    cp LICENSE.md $out/share
  '';

  meta = {
    description = "Shared library for Anytype clients";
    homepage = "https://anytype.io/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ autrimpo ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
