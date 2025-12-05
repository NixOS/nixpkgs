{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
  version = "31.1.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    tag = "${finalAttrs.version}";
    hash = "sha256-hcLjvIi7EZQSr99OLHGWesziBc5HhkvD+dmGOTgOY/c=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-lt/xIm7brU9itYhVdmmts5WpcZtQbWYcxXaRYKYp9H0=";

  meta = {
    description = "Language server for Prisma";
    homepage = "https://github.com/prisma/language-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "prisma-language-server";
  };
})
