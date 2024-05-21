# From this folder, run with:
#   `nix-build .`
{ pkgs ? (import ../../.. { config = {}; overlays = []; }) }:
let
  inherit (pkgs.lib) getBin;
  inherit (pkgs.lib.lists) map;
  inherit (pkgs.lib.strings) concatStringsSep toJSON;

  data = pkgs.writeText "python-interpreter-table.md"
    (toJSON (import ./collect-data { inherit pkgs; inherit (pkgs) lib; }));

  headers = ''["Package","Aliases", "Interpreter"]'';
  keys = ''[.pkgKey, (if .aliases == null then "" else .aliases|join(", ") end) , .interpreter]'';

in pkgs.runCommand "python-table-md" { inherit data; } ''
  export PATH=$PATH:${with pkgs; lib.makeBinPath [ jq unixtools.column ]}
  cat $data \
    | jq -r '(${headers} | (., map(length*"-"))), (.[] | ${keys}) | @tsv' -- \
    | column -t -s$'\t' -o ' | ' \
    | awk '{print "| "$0" |"}' > $out
''
