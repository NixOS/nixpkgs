# example tags:
# date="2007-20-10"; (get the last version before given date)
# tag="<tagname>" (get version by tag name)
# If you don't specify neither one date="NOW" will be used (get latest)

{
  stdenvNoCC,
  cvs,
  openssh,
  lib,
}:

lib.makeOverridable (
  lib.fetchers.withNormalizedHash { } (
    {
      cvsRoot,
      module,
      tag ? null,
      date ? null,
      outputHash,
      outputHashAlgo,
    }:

    stdenvNoCC.mkDerivation {
      name = "cvs-export";
      builder = ./builder.sh;
      nativeBuildInputs = [
        cvs
        openssh
      ];

      inherit outputHash outputHashAlgo;
      outputHashMode = "recursive";

      inherit
        cvsRoot
        module
        tag
        date
        ;
    }
  )
)
