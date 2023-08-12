{ lib
, fetchFromGitHub
, melpaBuild
, js2-mode
, writeText
}:

let
  rev = "5283ca7403bcb21ca0cac8ecb063600752dfd9d4";
in melpaBuild {
  pname = "prisma-mode";
  version = "20211207.0";

  commit = rev;

  packageRequires = [ js2-mode ];

  src = fetchFromGitHub {
    owner = "pimeys";
    repo = "emacs-prisma-mode";
    inherit rev;
    sha256 = "sha256-DJJfjbu27Gi7Nzsa1cdi8nIQowKH8ZxgQBwfXLB0Q/I=";
  };

  recipe = writeText "recipe" ''
    (prisma-mode :repo "pimeys/emacs-prisma-mode" :fetcher github)
  '';

  meta = {
    description = "Major mode for Prisma Schema Language";
    license = lib.licenses.gpl2Only;
  };
}
