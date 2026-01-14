{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protobuf-language-server";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "lasorda";
    repo = "protobuf-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bDsvByXa2kH3DnvQpAq79XvwFg4gfhtOP2BpqA1LCI0=";
  };

  vendorHash = "sha256-dRria1zm5Jk7ScXh0HXeU686EmZcRrz5ZgnF0ca9aUQ=";

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
