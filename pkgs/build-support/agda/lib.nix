{ lib }:
{
  /* Returns the Agda interface file to a given Agda file.
  *
  * Examples:
  * interfaceFile "Everything.agda" == "Everything.agdai"
  * interfaceFile "src/Everything.lagda.tex" == "src/Everything.agdai"
  */
  interfaceFile = agdaFile: lib.head (builtins.match ''(.*\.)l?agda(\.(md|org|rst|tex))?'' agdaFile) + "agdai";

  /* Takes an arbitrary derivation and says whether it is an agda library package
  *  that is not marked as broken.
  */
  isUnbrokenAgdaPackage = pkg: pkg.isAgdaDerivation or false && !pkg.meta.broken;
}
