# From this folder, run with:
#   `nix-build .`
{ pkgs ? (import ../../.. { config = {}; overlays = []; }) }:
let
  inherit (pkgs.lib) getBin;
  inherit (pkgs.lib.lists) map;
  inherit (pkgs.lib.strings) concatStringsSep toJSON;

  paths = let
    inputs = [ pkgs.jq pkgs.unixtools.column ];
  in concatStringsSep ":" (map (x: "${(getBin x).outPath}/bin") inputs);

  data = pkgs.writeText "python-interpreter-table.md"
    (toJSON (import ./collect-data { inherit pkgs; }));

  headers = ''["Package","Aliases", "Interpreter"]'';
  keys = ''[.pkgKey, (if .aliases == null then "" else .aliases|join(", ") end) , .interpreter]'';

in pkgs.runCommand "python-table-md" { inherit paths data; } ''
  export PATH=$PATH:$paths
  cat $data \
    | jq -r '(${headers} | (., map(length*"-"))), (.[] | ${keys}) | @tsv' -- \
    | column -t -s$'\t' -o ' | ' \
    | awk '{print "| "$0" |"}' > $out
''