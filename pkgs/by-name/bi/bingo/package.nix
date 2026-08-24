{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "bingo";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bwplotka";
    repo = "bingo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8rkKYX1LlDLR2NK59YyH15KyP0HQsbwN/K1uKXg1nq8=";
  };

  vendorHash = "sha256-7Si2TyH9RKnD5+TvcLSbgZ95ZyEvs7BfadIsnxuEY1U=";

  postPatch = ''
    rm get_e2e_test.go get_e2e_utils_test.go
  '';

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Like `go get` but for Go tools! CI Automating versioning of Go binaries in a nested, isolated Go modules";
    mainProgram = "bingo";
    homepage = "https://github.com/bwplotka/bingo";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
