# `fetchPypi` function for fetching artifacts from PyPI.
{ fetchurl
, lib
}:
let
  calculateUrl = { pname, version, workspace }:
    let
      endpoint =
        if workspace != "" then "${workspace}/${pname}/-/${pname}-${version}"
        else "${pname}/-/${pname}-${version}";
    in
    "https://registry.npmjs.org/${endpoint}.tgz";
in
lib.makeOverridable ({ pname
                     , version
                     , workspace ? ""
                     , hash
                     , ...
                     }@args:
let
  url = calculateUrl { inherit pname version workspace; };
in
fetchurl { inherit url hash; } // args)
