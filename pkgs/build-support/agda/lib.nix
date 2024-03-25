{ lib }:
{
  /**
    Returns the Agda interface file to a given Agda file.
    *
    * Examples:
    * interfaceFile "Everything.agda" == "Everything.agdai"
    * interfaceFile "src/Everything.lagda.tex" == "src/Everything.agdai"


    # Inputs

    `agdaFile`

    : 1\. Function argument
  */
  interfaceFile = agdaFile: lib.head (builtins.match ''(.*\.)l?agda(\.(md|org|rst|tex|typ))?'' agdaFile) + "agdai";

  /**
    Takes an arbitrary derivation and says whether it is an agda library package
    *  that is not marked as broken.


    # Inputs

    `pkg`

    : 1\. Function argument
  */
  isUnbrokenAgdaPackage = pkg: pkg.isAgdaDerivation or false && !pkg.meta.broken;
}
