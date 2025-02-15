{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-validate";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
    sha256 = "sha256-kGnfR8o12bvjJH+grAwlYezF6UzWt7lgjGslq+07p3k=";
  };

  vendorHash = "sha256-c7zi1y3HWGyjE2xG60msCUdKCTkwhWit2x5gU/bLoec=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
  };
}
