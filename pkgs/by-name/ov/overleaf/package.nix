{ lib
, buildNpmPackage
, nodejs_18
, fetchFromGitHub
, callPackage
, fetchNpmDeps
, python3
}:

let
  patchGitDeps = src: src.overrideAttrs (_: _: {
    postPatch = ''
    '';

    installPhase = ''
      mkdir $out
      cp -r * $out
    '';
  });
in

(buildNpmPackage.override { nodejs = nodejs_18; }) rec {
  pname = "overleaf";
  version = "4.2";

  # This repository is fork of overleaf/overleaf where the git dependencies
  # have been linked as local dependencies to ./libraries.
  # Pending on upstream fix: https://github.com/overleaf/overleaf/issues/1187
  # We probably can package the 14 git dependencies in nixpkgs
  # to avoid this.
  src = fetchFromGitHub {
    owner = "saumonnet";
    repo = "overleaf";
    rev = "6ee9a0c8cf8142e930de4b360d5a737d26aa6030";
    hash = "sha256-tsE+8tiuhsbc1L959JEngVEYNuJxNXeMxEiPT+BF7kk=";
    fetchSubmodules = true;
  };

  # Fix ace-builds path due to git dependencies workaround
  patches = [ ./ace-builds.patch ];

  postPatch = ''
    # Remove useless prepare scripts in git dependencies
    find libraries -name "package.json" -exec sed -i {} -e 's/"prepare": ".*"/"prepare": ""/' \;
  '';

  npmDeps = fetchNpmDeps {
    inherit src postPatch;
    name = "${pname}-${version}-npm-deps";
    hash = "sha256-2tdOYghca1UmTG1ZnpUUaZ2bmw0YgzwtKiA7V4DDeq8=";
  };

  npmRebuildFlags = [ "--ignore-scripts" "--loglevel=verbose" ];
  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  npmWorkspace = "services/web";
  npmBuildScript = "webpack:production";
  nativeBuildInputs = [ nodejs_18 ];
  buildInputs = [ python3 ];

  preBuild = ''
    (
      ls -all /build
      cd node_modules/bcrypt
      export CPPFLAGS="-I${nodejs_18}/include/node"
      ${nodejs_18.pkgs.node-pre-gyp}/bin/node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs_18}/include/node
    )
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share
  '';

  postFixup = ''
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-chat \
      --add-flags start \
      --chdir $out/share/services/chat
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-clsi \
      --add-flags start \
      --chdir $out/share/services/clsi
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-contacts \
      --add-flags start \
      --chdir $out/share/services/contacts
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-docstore \
      --add-flags start \
      --chdir $out/share/services/docstore
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-document-updater \
      --add-flags start \
      --chdir $out/share/services/document-updater
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-filestore \
      --add-flags start \
      --chdir $out/share/services/filestore
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-git-bridge \
      --add-flags start \
      --chdir $out/share/services/git-bridge
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-history-v1 \
      --add-flags start \
      --chdir $out/share/services/history-v1
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-notifications \
      --add-flags start \
      --chdir $out/share/services/notifications
    makeWrapper ${nodejs_18}/bin/npm $out/bin/project-history \
      --add-flags start \
      --chdir $out/share/services/project-history
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-real-time \
      --add-flags start \
      --chdir $out/share/services/real-time
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-spelling \
      --add-flags start \
      --chdir $out/share/services/spelling
    makeWrapper ${nodejs_18}/bin/npm $out/bin/overleaf-web \
      --add-flags start \
      --chdir $out/share/services/web
  '';

  meta = with lib; {
    description = "A web-based collaborative LaTeX editor";
    homepage = "https://github.com/overleaf/overleaf";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ camillemndn julienmalka ];
    mainProgram = "overleaf";
    platforms = platforms.unix;
  };
}
