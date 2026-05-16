{
  lib,
  fetchurl,
  runCommand,
  writeText,
}:

{
  name ? "deps",
  data,
  dontFixup ? true,
  ...
}@attrs:

let
  data' = removeAttrs (if builtins.isPath data then lib.importJSON data else data) [
    "!version"
  ];

  urlToPath =
    url:
    if lib.hasPrefix "https://" url then
      (
        let
          url' = lib.drop 2 (lib.splitString "/" url);
        in
        "https/${builtins.concatStringsSep "/" url'}"
      )
    else
      builtins.replaceStrings [ "://" ] [ "/" ] url;
  code = ''
    mkdir -p "$out"
    cd "$out"
  ''
  + builtins.concatStringsSep "" (
    lib.mapAttrsToList (
      url: info:
      let
        key = builtins.head (builtins.attrNames info);
        val = info.${key};
        path = urlToPath url;
        name = baseNameOf path;
        source =
          {
            redirect = "$out/${urlToPath val}";
            hash = fetchurl {
              inherit url;
              hash = val;
            };
            text = writeText name val;
          }
          .${key} or (throw "Unknown key: ${url}");
      in
      ''
        mkdir -p "${dirOf path}"
        ln -s "${source}" "${path}"
      ''
    ) data'
  );
in
runCommand name (
  removeAttrs attrs [
    "name"
    "data"
  ]
  // {
    passthru = (attrs.passthru or { }) // {
      data = writeText "deps.json" (builtins.toJSON data);
    };
  }
) code
