{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
  version = "6.16.2";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    tag = "${finalAttrs.version}";
    hash = "sha256-UZP0pLcbMeaYI0ytOJ68l/ZEC9dBhohJZyTU99p+1QM=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-UAGz/qCYf+jsgCWqvR52mW6Ze3WWP9EHuE4k9wCbnH0=";

  meta = {
    description = "Language server for Prisma";
    homepage = "https://github.com/prisma/language-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "prisma-language-server";
  };
})
