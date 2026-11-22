{
  lib,
  fetchurl,
  perlPackages,
}:
let
  version = "2.02";
in
perlPackages.buildPerlPackage {
  pname = "File-Rename";
  inherit version;

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RM/RMBARKER/File-Rename-${version}.tar.gz";
    hash = "sha256-U3tggAi2gTba4Li9Gv5eq3UmS7ZLsXg57mW9tHTFIN8=";
  };

  meta = {
    description = "Perl extension for renaming multiple files";
    license = lib.licenses.artistic1;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "rename";
  };
}
