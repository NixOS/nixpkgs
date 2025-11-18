{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
  version = "6.19.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    tag = "${finalAttrs.version}";
    hash = "sha256-v+gCxUuwrLdl2rlvB2HGZvXZEdSxmdUrY1YE58iBKRQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-4NQO48a2f4k6CSWmIc/7UavNPNkAVIg0OyYArt/+vxI=";

  meta = {
    description = "Language server for Prisma";
    homepage = "https://github.com/prisma/language-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "prisma-language-server";
  };
})
