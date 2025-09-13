{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "prisma-language-server";
  version = "6.15.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "language-tools";
    rev = finalAttrs.version;
    hash = "sha256-bmWKH9gEoFFVNMhpncSYwqz764vuqCk6qrzyjXOPdN0=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/language-server";
  npmDepsHash = "sha256-XTGiQiaEIxf+UIu3m28AaDJw5ekDJU96nmkUE75OcQg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Prisma Language Server";
    homepage = "https://github.com/prisma/language-tools/tree/${finalAttrs.version}/packages/language-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ imatpot ];
  };
})
