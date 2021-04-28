{ lib }:
{
  /* Returns the Agda interface file to a given Agda file.
  *
  * Examples:
  * interfaceFile "Everything.agda" == "Everything.agdai"
  * interfaceFile "src/Everything.lagda.tex" == "src/Everything.agdai"
  */
  interfaceFile = agdaFile: lib.head (builtins.match ''(.*\.)l?agda(\.(md|org|rst|tex))?'' agdaFile) + "agdai";
}
