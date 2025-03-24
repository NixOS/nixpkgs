{
  lib,
  stdenv,
  buildNpmPackage,
  importNpmLock,
  symlinkJoin,
  fetchFromGitHub,
  nix-update-script,
}:

let
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "archtika";
    repo = "archtika";
    tag = "v${version}";
    hash = "sha256-GffYAtLs12v2Lt1WoKJOG5dZsmzDcySZKFBQwCT9nnY=";
  };

  web = buildNpmPackage {
    name = "web-app";
    src = "${src}/web-app";
    npmDepsHash = "sha256-2udi8vLLvdoZxIyRKLOCfEpEMsooxsIrM1wiua1QPAI=";
    npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      mkdir -p $out/web-app
      cp package.json $out/web-app
      cp -r node_modules $out/web-app
      cp -r build/* $out/web-app
      cp -r template-styles $out/web-app
    '';
  };

  api = stdenv.mkDerivation {
    name = "api";
    src = "${src}/rest-api";
    installPhase = ''
      mkdir -p $out/rest-api/db/migrations
      cp -r db/migrations/* $out/rest-api/db/migrations
    '';
  };
in
symlinkJoin {
  pname = "archtika";
  inherit version;

  paths = [
    web
    api
  ];

  passthru = {
    inherit src web;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern, performant and lightweight CMS";
    homepage = "https://archtika.com";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.thiloho ];
    platforms = lib.platforms.unix;
  };
}
