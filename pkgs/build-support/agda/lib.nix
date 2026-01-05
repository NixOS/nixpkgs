{ lib }:
{
  /*
    Returns the Agda interface file to a given Agda file.
    *
    * The resulting path may not be normalized.
    *
    * Examples:
    * interfaceFile pkgs.agda.version "./Foo.agda" == "_build/AGDA_VERSION/agda/./Foo.agdai"
    * interfaceFile pkgs.agda.version "src/Foo.lagda.tex" == "_build/AGDA_VERSION/agda/src/Foo.agdai"
  */
  interfaceFile =
    agdaVersion: agdaFile:
    "_build/"
    + agdaVersion
    + "/agda/"
    + lib.head (builtins.match ''(.*\.)l?agda(\.(md|org|rst|tex|typ))?'' agdaFile)
    + "agdai";

  /*
    Takes an arbitrary derivation and says whether it is an agda library package
    *  that is not marked as broken.
  */
  isUnbrokenAgdaPackage = pkg: pkg.isAgdaDerivation or false && !pkg.meta.broken;
}
