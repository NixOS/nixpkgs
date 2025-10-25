{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pg-schema-diff";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "stripe";
    repo = "pg-schema-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u0niTTqrzsI4u0OGY5qkgbitadcbEK/ElFGnPJsEMwo=";
  };

  vendorHash = "sha256-Hs3xrGP8eJwW3rQ9nViB9sqC8spjHV6rCoy1u/SYHak=";

  # Errors with `postgres executable not found in path`
  doCheck = false;

  meta = {
    description = "Go library for diffing Postgres schemas and generating SQL migrations";
    homepage = "https://github.com/stripe/pg-schema-diff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bitbloxhub ];
    mainProgram = "pg-schema-diff";
  };
})
