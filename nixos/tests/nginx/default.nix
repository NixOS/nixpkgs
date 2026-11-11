{ lib, runTest, ... }:
let
  inherit (lib) recurseIntoAttrs mapAttrs const;

  packages = {
    mainline = builtins.getAttr "nginxMainline";
    stable = builtins.getAttr "nginxStable";
  };

  callTest =
    mkPackage: name: path:
    runTest (import path { inherit mkPackage name lib; });

  tests = {
    auth = ./auth.nix;
    basic = ./basic.nix;
    compression = ./compression.nix;
    etag = ./etag.nix;
    etag-compression = ./etag-compression.nix;
    globalredirect = ./globalredirect.nix;
    http3 = ./http3.nix;
    dynamic-modules = ./dynamic-modules.nix;
    grpc-error-pages = ./grpc-error-pages.nix;
    lua = ./lua.nix;
    mime = ./mime.nix;
    modsecurity = ./modsecurity.nix;
    moreheaders = ./moreheaders.nix;
    njs = ./njs.nix;
    otel = ./otel.nix;
    proxyprotocol = ./proxyprotocol;
    pubhtml = ./pubhtml.nix;
    sso = ./sso.nix;
    status-page = ./status-page.nix;
    tmpdir = ./tmpdir.nix;
    unix-socket = ./unix-socket.nix;
  };

  mkTestCases =
    tests: name: mkPackage:
    let
      callTest' = callTest mkPackage name;
    in
    mapAttrs (const callTest') tests;
in
recurseIntoAttrs (mapAttrs (mkTestCases tests) packages)
// {
  inherit callTest tests;
}
