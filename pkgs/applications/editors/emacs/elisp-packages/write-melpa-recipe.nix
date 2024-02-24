{ lib
, writeText
}:

{ package-name
, fetcher
, url ? ""
, repo ? ""
, commit ? ""
, branch ? ""
, version-regexp ? ""
, files ? ""
, old-names ? ""
}:

let
  recognizedForges = [ "codeberg" "github" "gitlab" "sourcehut" ];
  recognizedVCSes = [ "git" "hg" ];
  unlessEmpty = attr: tag:
    lib.optionals (attr != "") [ '' :${tag} ${attr} '' ];
  unlessEmptyStr = attr: tag:
    lib.optionals (attr != "") [ '' :${tag} "${attr}" '' ];
in
assert package-name != "";
assert fetcher != "";
assert lib.subtractLists (recognizedForges ++ recognizedVCSes) [ fetcher ] == [];
assert (lib.subtractLists recognizedVCSes [ fetcher ] == []) ->
       (url != "" && repo == "");
assert (lib.subtractLists recognizedForges [ fetcher ] == []) ->
       (url == "" && repo != "");
writeText "recipe"
  (lib.concatStringsSep "\n"
    ([ "(${package-name}" ] ++
     (unlessEmpty fetcher "fetcher") ++
     (unlessEmptyStr url "url") ++
     (unlessEmptyStr repo "repo") ++
     (unlessEmptyStr commit "commit") ++
     (unlessEmptyStr branch "branch") ++
     (unlessEmptyStr version-regexp "version-regexp") ++
     (unlessEmpty files "files") ++
     (unlessEmpty old-names "old-names") ++
     [ ")" ]))
