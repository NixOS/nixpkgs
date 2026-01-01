{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
<<<<<<< HEAD
  version = "31.1.0";
=======
  version = "6.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    tag = "${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-hcLjvIi7EZQSr99OLHGWesziBc5HhkvD+dmGOTgOY/c=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-lt/xIm7brU9itYhVdmmts5WpcZtQbWYcxXaRYKYp9H0=";
=======
    hash = "sha256-v+gCxUuwrLdl2rlvB2HGZvXZEdSxmdUrY1YE58iBKRQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-4NQO48a2f4k6CSWmIc/7UavNPNkAVIg0OyYArt/+vxI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Language server for Prisma";
    homepage = "https://github.com/prisma/language-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mmkaram ];
    mainProgram = "prisma-language-server";
  };
})
