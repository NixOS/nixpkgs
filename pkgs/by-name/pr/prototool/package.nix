{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  protobuf,
}:

buildGoModule rec {
  pname = "prototool";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "uber";
    repo = "prototool";
    rev = "v${version}";
    hash = "sha256-T6SjjyHC4j5du2P4Emcfq/ZFbuCpMPPJFJTHb/FNMAo=";
  };

  vendorHash = "sha256-W924cy6bd3V/ep3JmzUCV7iuYNukEetr90SKmLMH0j8=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  postInstall = ''
    wrapProgram "$out/bin/prototool" \
      --prefix PROTOTOOL_PROTOC_BIN_PATH : "${protobuf}/bin/protoc" \
      --prefix PROTOTOOL_PROTOC_WKT_PATH : "${protobuf}/include"
  '';

  subPackages = [ "cmd/prototool" ];

  meta = with lib; {
    homepage = "https://github.com/uber/prototool";
    description = "Your Swiss Army Knife for Protocol Buffers";
    mainProgram = "prototool";
    maintainers = [ ];
    license = licenses.mit;
  };
}
