# From this folder, run with:
#   `nix-build .`
{ pkgs ? (import ../../.. { config = {}; overlays = []; }) }:
let
  inherit (pkgs.lib) getBin;
  inherit (pkgs.lib.lists) map;
  inherit (pkgs.lib.strings) concatStringsSep toJSON;

  data = pkgs.writeText "python-interpreter-table.md"
    (toJSON (import ./collect-data { inherit pkgs; inherit (pkgs) lib; }));

in pkgs.runCommand "python-table-md" {
    EXTRA_PATH = with pkgs; lib.makeBinPath [ jq unixtools.column ];
    inherit data;
  } ''
  export PATH=$PATH:$EXTRA_PATH
  cat > $out << EOF
  | Package | Aliases | Interpeter |
  |-|-|-|
  EOF
  cat $data \
    | jq --raw-output '(.[] | [.attrname, .aliases, .interpreter]) | @tsv' -- \
    | column -t -s$'\t' -o ' | ' \
    | awk '{print "| "$0" |"}' >> $out
  ''
