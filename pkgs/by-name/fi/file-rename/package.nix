{
  lib,
  fetchurl,
  perlPackages,
}:

perlPackages.buildPerlPackage {
  pname = "File-Rename";
  version = "2.02";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RM/RMBARKER/File-Rename-2.02.tar.gz";
    hash = "sha256-U3tggAi2gTba4Li9Gv5eq3UmS7ZLsXg57mW9tHTFIN8=";
  };

  meta = {
    description = "Perl extension for renaming multiple files";
    license = lib.licenses.artistic1;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "rename";
  };
}
