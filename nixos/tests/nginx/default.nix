{ lib, runTest, ... }:
let
  inherit (lib) recurseIntoAttrs mapAttrs const;

  packages = {
    mainline = builtins.getAttr "nginxMainline";
    stable = builtins.getAttr "nginxStable";
  };
in
recurseIntoAttrs (
  mapAttrs (
    name: mkPackage:
    let
      callTest = path: runTest (import path { inherit mkPackage name lib; });
    in
    mapAttrs (const callTest) {
      auth = ./auth.nix;
      basic = ./basic.nix;
      compression = ./compression.nix;
      etag = ./etag.nix;
      etag-compression = ./etag-compression.nix;
      globalredirect = ./globalredirect.nix;
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
    }
  ) packages
)
