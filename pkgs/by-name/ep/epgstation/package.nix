{
  lib,
  fetchpatch,
  fetchFromGitHub,
  buildNpmPackage,
  installShellFiles,
  makeWrapper,
  bash,
  nodejs,
  python3,
}:

buildNpmPackage rec {
  pname = "epgstation";
  version = "2.6.20";

  src = fetchFromGitHub {
    owner = "l3tnun";
    repo = "EPGStation";
    rev = "v${version}";
    sha256 = "K1cAvmqWEfS6EY4MKAtjXb388XLYHtouxNM70PWgFig=";
  };

  patches = [
    ./use-mysql-over-domain-socket.patch

    # upgrade dependencies to make it compatible with node 18
    (fetchpatch {
      url = "https://github.com/midchildan/EPGStation/commit/5d6cad746b7d9b6d246adcdecf9c991b77c9d89e.patch";
      sha256 = "sha256-9a8VUjczlyQHVO7w9MYorPIZunAuBuif1HNmtp1yMk8=";
    })
    (fetchpatch {
      url = "https://github.com/midchildan/EPGStation/commit/c948e833e485c2b7cb7fb33b953cca1e20de3a70.patch";
      sha256 = "sha256-nM6KkVRURuQFZLXZ2etLU1a1+BoaJnfjngo07TFbe58=";
    })
  ];

  npmDepsHash = "sha256-dohencRGuvc+vSoclLVn5iles4GOuTq26BrEVeJ4GC4=";
  npmBuildScript = "build-server";
  npmRootPath = "/lib/node_modules/epgstation";

  buildInputs = [ bash ];
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    python3
  ];

  clientDir = buildNpmPackage {
    pname = "${pname}-client";
    inherit
      version
      src
      installPhase
      meta
      ;

    npmDepsHash = "sha256-a/cDPABWI4lPxvSOI4D90O71A9lm8icPMak/g6DPYQY=";
    npmRootPath = "";

    sourceRoot = "${src.name}/client";
    NODE_OPTIONS = "--openssl-legacy-provider";
  };

  postBuild = ''
    rm -rf client
    cp -r ${clientDir} client
  '';

  # installPhase is shared with clientDir
  installPhase = ''
    runHook preInstall

    npm prune --omit dev --no-save \
      $npmInstallFlags \
      "''${npmInstallFlagsArray[@]}" \
      $npmFlags \
      "''${npmFlagsArray[@]}"

    mkdir -p $out$npmRootPath
    cp -r . $out$npmRootPath

    runHook postInstall
  '';

  postInstall =
    let
      runtimeDeps = [
        nodejs
        bash
      ];
    in
    ''
      mkdir -p $out/{bin,libexec,share/doc/epgstation}

      pushd $out$npmRootPath

      mv config/enc.js.template $out/libexec/enc.js
      mv LICENSE Readme.md $out/share/doc/epgstation
      mv doc/* $out/share/doc/epgstation
      sed 's/@DESCRIPTION@/${meta.description}/g' ${./epgstation.1} > doc/epgstation.1
      installManPage doc/epgstation.1
      rm -rf doc

      # just log to stdout and let journald do its job
      rm -rf logs

      # Replace the existing configuration and runtime state directories with
      # symlinks. Without this, they would all be non-writable because they
      # reside in the Nix store. Note that the source path won't be accessible
      # at build time.
      rm -r config data drop recorded thumbnail src/db/subscribers src/db/migrations
      ln -sfT /etc/epgstation config
      ln -sfT /var/lib/epgstation data
      ln -sfT /var/lib/epgstation/drop drop
      ln -sfT /var/lib/epgstation/recorded recorded
      ln -sfT /var/lib/epgstation/thumbnail thumbnail
      ln -sfT /var/lib/epgstation/db/subscribers src/db/subscribers
      ln -sfT /var/lib/epgstation/db/migrations src/db/migrations

      makeWrapper ${nodejs}/bin/npm $out/bin/epgstation \
       --chdir $out$npmRootPath \
       --prefix PATH : ${lib.makeBinPath runtimeDeps} \
       --set APP_ROOT_PATH $out$npmRootPath

      popd
    '';

  meta = with lib; {
    description = "DVR software compatible with Mirakurun";
    homepage = "https://github.com/l3tnun/EPGStation";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    mainProgram = "epgstation";
  };
}
