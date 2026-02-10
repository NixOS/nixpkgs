{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-validate";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-225D0iHM+fTYIu/+HPkGZ8IcqbP4FMkf7Lw1wI02rZw=";
  };

  vendorHash = "sha256-R9zcjoMiq69pPbXAahOp1RJNvlgsASuCwbxkwLbMomg=";

  excludedPackages = [ "tests" ];

  meta = {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthewpi ];
  };
})
