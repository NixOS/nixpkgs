{ lib, runTest, ... }:
let
  inherit (lib) const mapAttrs recurseIntoAttrs;
  inherit (import ./nginx { inherit lib runTest; }) callTest tests;
in
recurseIntoAttrs (
  mapAttrs (const (callTest (builtins.getAttr "openresty") "openresty")) {
    inherit (tests) basic http3;
  }
)
