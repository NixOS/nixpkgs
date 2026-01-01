{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoc-gen-go";
<<<<<<< HEAD
  version = "1.36.11";
=======
  version = "1.36.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7+w3f5dDcQCw87A6P+JZXfMejS4QHANaLGK8QbUAaQs=";
=======
    hash = "sha256-7wAIwUouwmczSeAnA7aMmX8HwXmfnjNErgjjvx+wCZQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-EAkrbx9pTBhZ0y0ub14PnMINrk1M6yEgnGapzpgXqBU=";

  subPackages = [ "cmd/protoc-gen-go" ];

<<<<<<< HEAD
  meta = {
    description = "Go support for Google's protocol buffers";
    mainProgram = "protoc-gen-go";
    homepage = "https://google.golang.org/protobuf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jojosch ];
=======
  meta = with lib; {
    description = "Go support for Google's protocol buffers";
    mainProgram = "protoc-gen-go";
    homepage = "https://google.golang.org/protobuf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jojosch ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
