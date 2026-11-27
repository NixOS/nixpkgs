# This turns ./outpaths.nix into chunks of a fixed size.
{
  lib ? import ../../lib,
  path ? ../..,
  # The file containing the preEval result
  preEvalFile,
  chunkSize,
  myChunk,
  includeBroken,
  systems,
  defaultProblemHandler,
  extraNixpkgsConfigJson,
}:

let
  preEvalResult = lib.importJSON preEvalFile;
  myAttrpaths = lib.sublist (chunkSize * myChunk) chunkSize preEvalResult.paths;

  unfiltered = import ./outpaths.nix {
    inherit path;
    inherit includeBroken systems defaultProblemHandler;
    inherit (preEvalResult) attrPathsDisallowedForInternalUse;
    extraNixpkgsConfig = builtins.fromJSON extraNixpkgsConfigJson;
  };

  # Turns the unfiltered recursive attribute set into one that is limited to myAttrpaths
  filtered =
    let
      recurse =
        index: paths: attrs:
        lib.mapAttrs (
          name: values:
          if attrs ? ${name} then
            if lib.any (value: lib.length value <= index + 1) values then
              attrs.${name}
            else
              recurse (index + 1) values attrs.${name}
              # Make sure nix-env recurses as well
              // {
                recurseForDerivations = true;
              }
          else
            null
        ) (lib.groupBy (a: lib.elemAt a index) paths);
    in
    recurse 0 myAttrpaths unfiltered;

in
filtered
