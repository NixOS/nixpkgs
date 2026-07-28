{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protobuf-language-server";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lasorda";
    repo = "protobuf-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xaWcQMoahOVm6pAP8Y01fkSOuvuwS+aRFEb5ztbL3pk=";
  };

  vendorHash = "sha256-4nTpKBe7ekJsfQf+P6edT/9Vp2SBYbKz1ITawD3bhkI=";

  # TestMethodsGen overwrites go-lsp/lsp/methods_gen.go with missing imports.
  # This causes other tests to break.
  checkFlags = [ "-skip=TestMethodsGen" ];

  meta = {
    description = "Language server implementation for Google Protocol Buffers";
    mainProgram = "protobuf-language-server";
    homepage = "https://github.com/lasorda/protobuf-language-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bizmyth ];
  };
})
