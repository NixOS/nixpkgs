{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "protoc-gen-lint";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ckaznocha";
    repo = "protoc-gen-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8+fPkXmigP8ZqcFGCnw1KZhJQcahDjKnZUJ1eqaHhs0=";
  };

  vendorHash = null;

  meta = {
    description = "Plug-in for Google's Protocol Buffers compiler to check .proto files for style violations";
    homepage = "https://github.com/ckaznocha/protoc-gen-lint";
    changelog = "https://github.com/ckaznocha/protoc-gen-lint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jherland
      jk
    ];
    mainProgram = "protoc-gen-lint";
  };
})
