{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-validate";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YujY2XNNtrVw7+kUxSwF9gbD2AzPV6zKV0zSun89VEY=";
  };

  vendorHash = "sha256-r4oT4Jd21hQccvGEqOXpEKqUy6lvMKN+vF8e2KxY6oQ=";

  excludedPackages = [ "tests" ];

  meta = {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthewpi ];
  };
})
