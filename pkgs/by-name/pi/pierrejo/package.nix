{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  runCommand,
}:

let
  src = fetchFromGitHub {
    owner = "harivansh-afk";
    repo = "pierrejo";
    rev = "a1960a6ae2d4d933394f245ae679f7e1fcc7ad70";
    hash = "sha256-gj0Z32iV3bTXEx+VE3P6iGLr7vmN6D7aLCgLHEVnOOc=";
  };

  version = "0-unstable-2026-05-25";

  ssrPackage = buildNpmPackage {
    pname = "pierrejo-ssr";
    inherit version;

    __structuredAttrs = true;

    src = "${src}/ssr";

    npmDepsHash = "sha256-fIj9bUjAYvnIe2o1IT9l9wr8tn1MtomNKb/dvLYfiGQ=";

    dontNpmBuild = true;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/pierrejo-ssr
      cp -R . $out/lib/pierrejo-ssr
      makeWrapper ${lib.getExe nodejs} $out/bin/pierre-ssr --add-flags $out/lib/pierrejo-ssr/server.js

      runHook postInstall
    '';

    meta = {
      description = "Server-side rendering sidecar for Pierre diffs in Forgejo";
      homepage = "https://github.com/harivansh-afk/pierrejo";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [ conao3 ];
      mainProgram = "pierre-ssr";
      platforms = lib.platforms.all;
    };
  };

  assets = runCommand "pierrejo-forgejo-assets-${version}" { } ''
    mkdir -p $out/css
    cp ${src}/assets/css/pierre-forgejo.css $out/css/pierre-forgejo.css
  '';
in
buildNpmPackage {
  pname = "pierrejo";
  inherit version;

  __structuredAttrs = true;

  src = "${src}/frontend";

  npmDepsHash = "sha256-wIyJ3Af65p615GqhbxUbvetOlOTe1Rg75oYAsQnLvPA=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/js
    cp -R dist/. $out/js/

    runHook postInstall
  '';

  passthru = {
    inherit assets ssrPackage;

    patches = [
      "${src}/patches/forgejo-15.0.2/0001-pierre-ssr-highlighting.patch"
      "${src}/patches/forgejo-15.0.2/0002-expose-init-globals.patch"
    ];

    templates = "${src}/templates";

    mkForgejoWithPierre =
      forgejoPackage:
      forgejoPackage.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          "${src}/patches/forgejo-15.0.2/0001-pierre-ssr-highlighting.patch"
          "${src}/patches/forgejo-15.0.2/0002-expose-init-globals.patch"
        ];
      });
  };

  meta = {
    description = "Pierre diffs integration layer for Forgejo";
    homepage = "https://github.com/harivansh-afk/pierrejo";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ conao3 ];
    platforms = lib.platforms.all;
  };
}
