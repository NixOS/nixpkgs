{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-go";
  version = "1.36.12";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1jaQXOwy5x2Yqzkkb5l/kbOhFVUgZ0N1yemDhgq32VE=";
  };

  vendorHash = "sha256-EAkrbx9pTBhZ0y0ub14PnMINrk1M6yEgnGapzpgXqBU=";

  subPackages = [ "cmd/protoc-gen-go" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Go support for Google's protocol buffers";
    mainProgram = "protoc-gen-go";
    homepage = "https://google.golang.org/protobuf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jojosch ];
  };
})
