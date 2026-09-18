{
  lib,
  fetchFromGitHub,
  melpaBuild,
  js2-mode,
  lsp-mode,
}:

melpaBuild {
  pname = "prisma-mode";
  version = "0-unstable-2021-12-07";

  packageRequires = [
    js2-mode
    lsp-mode
  ];

  src = fetchFromGitHub {
    owner = "pimeys";
    repo = "emacs-prisma-mode";
    rev = "5283ca7403bcb21ca0cac8ecb063600752dfd9d4";
    hash = "sha256-DJJfjbu27Gi7Nzsa1cdi8nIQowKH8ZxgQBwfXLB0Q/I=";
  };

  meta = {
    description = "Major mode for Prisma Schema Language";
    license = lib.licenses.gpl2Only;
  };
}
