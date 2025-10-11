{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
  version = "6.17.1";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    tag = "${finalAttrs.version}";
    hash = "sha256-L2THhIjCeoNRUWTQ0aMkXeatjunRPhd0m4No5UE11lI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-Fa6Eajzm3/NHHr4ngsgJ/CFfEcQ2J3DTEQEUcK7ZdeU=";

  meta = {
    description = "Language server for Prisma";
    homepage = "https://github.com/prisma/language-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "prisma-language-server";
  };
})
