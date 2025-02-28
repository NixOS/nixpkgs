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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "archtika";
    repo = "archtika";
    tag = "v${version}";
    hash = "sha256-ba9da7LqCE/e2lhRVHD7GOhwOj1fNTBbN/pARPMzIg4=";
  };

  web = buildNpmPackage {
    name = "web-app";
    src = "${src}/web-app";
    npmDepsHash = "sha256-RTyo7K/Hr1hBGtcBKynrziUInl91JqZl84NkJg16ufA=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, performant and lightweight CMS";
    homepage = "https://archtika.com";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.thiloho ];
    platforms = lib.platforms.unix;
  };
}
