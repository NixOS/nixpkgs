{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-validate";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = "protoc-gen-validate";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-225D0iHM+fTYIu/+HPkGZ8IcqbP4FMkf7Lw1wI02rZw=";
  };

  vendorHash = "sha256-R9zcjoMiq69pPbXAahOp1RJNvlgsASuCwbxkwLbMomg=";

  excludedPackages = [ "tests" ];

  meta = {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthewpi ];
=======
    sha256 = "sha256-kGnfR8o12bvjJH+grAwlYezF6UzWt7lgjGslq+07p3k=";
  };

  vendorHash = "sha256-c7zi1y3HWGyjE2xG60msCUdKCTkwhWit2x5gU/bLoec=";

  excludedPackages = [ "tests" ];

  meta = with lib; {
    description = "Protobuf plugin for generating polyglot message validators";
    homepage = "https://github.com/envoyproxy/protoc-gen-validate";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthewpi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
