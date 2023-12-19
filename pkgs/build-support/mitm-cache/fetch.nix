{ lib
, fetchurl
, runCommand
, writeText
}:

{ name ? "deps"
, data
, dontFixup ? true
, ...
}
@ attrs:

let
  data' = if builtins.isPath data then builtins.fromJSON (builtins.readFile data) else data;
  urlToPath = url:
    if lib.hasPrefix "https://" url then (
      let
        url' = lib.drop 2 (lib.splitString "/" url);
      in "https/${builtins.concatStringsSep "/" url'}"
    )
    else builtins.replaceStrings ["://"] ["/"] url;
  code = ''
    mkdir -p "$out"
    cd "$out"
  '' + builtins.concatStringsSep "" (lib.mapAttrsToList (url: info:
  let
    key = builtins.head (builtins.attrNames info);
    val = info.${key};
    path = urlToPath url;
    name = baseNameOf path;
    source = {
      redirect = "$out/${urlToPath val}";
      sha256 = fetchurl { inherit url; sha256 = val; };
      text = writeText name val;
    }.${key} or (throw "Unknown key: ${url}");
  in ''
    mkdir -p "${dirOf path}"
    ln -s "${source}" "${path}"
  '') data');
in
  runCommand name (builtins.removeAttrs attrs [ "name" "data" ]) code
