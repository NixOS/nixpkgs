{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pgbot";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "pgrundev";
    repo = "pgbot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-khQVFOGqsIaVUDBlDOdA48xdqmxF4YhwYGXYnAiaJ/o=";
  };

  vendorHash = "sha256-A6BqprG7/Fi1Yi7jrVIlpxfyvfKmAyzUR2JEr+yoFTA=";

  subPackages = [ "cmd/pgbot" ];

  __structuredAttrs = true;

  env.CGO_ENABLED = "0";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = true;

  meta = {
    description = "In-database observability for PostgreSQL";
    longDescription = ''
      pgbot is a read-only PostgreSQL observability CLI. A single static
      binary connects with a read-only role, reads Postgres's own
      statistics views, and prints findings-first health reports plus
      diffs against previous runs. No agent, no external service, no
      write privilege anywhere in the path.
    '';
    homepage = "https://github.com/pgrundev/pgbot";
    changelog = "https://github.com/pgrundev/pgbot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "pgbot";
  };
})
