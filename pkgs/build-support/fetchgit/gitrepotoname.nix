{ lib }:

let
  inherit (lib) removeSuffix hasPrefix removePrefix splitString stringToCharacters concatMapStrings last elem;

  allowedChars = stringToCharacters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-._?=";
  sanitizeStoreName = s:
    let
      s' = concatMapStrings (c: if elem c allowedChars then c else "") (stringToCharacters s);
      s'' = if hasPrefix "." s' then "_${removePrefix "." s'}" else s';
    in
      s'';
in
  urlOrRepo: rev:
    let
      repo' = last (splitString ":" (baseNameOf (removeSuffix ".git" (removeSuffix "/" urlOrRepo))));
      rev' = baseNameOf rev;
    in
     "${sanitizeStoreName repo'}-${sanitizeStoreName rev'}-src"
