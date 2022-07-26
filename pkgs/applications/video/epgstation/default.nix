{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, writers
, makeWrapper
, bash
, nodejs
, nodePackages
, gzip
, jq
, yq
}:

let
  # NOTE: use updateScript to bump the package version
  pname = "EPGStation";
  version = "2.6.20";
  src = fetchFromGitHub {
    owner = "l3tnun";
    repo = "EPGStation";
    rev = "v${version}";
    sha256 = "K1cAvmqWEfS6EY4MKAtjXb388XLYHtouxNM70PWgFig=";
  };

  client = nodePackages.epgstation-client.override (drv: {
    # FIXME: remove this option if possible
    #
    # Unsetting this option resulted NPM attempting to re-download packages.
    dontNpmInstall = true;

    meta = drv.meta // {
      inherit (nodejs.meta) platforms;
    };
  });

  server = nodePackages.epgstation.override (drv: {
    inherit src;

    # This is set to false to keep devDependencies at build time. Build time
    # dependencies are pruned afterwards.
    production = false;

    buildInputs = (drv.buildInputs or [ ]) ++ [ bash ];
    nativeBuildInputs = (drv.nativeBuildInputs or [ ]) ++ [
      makeWrapper
    ];

    preRebuild = ''
      # Fix for not being able to connect to mysql using domain sockets.
      patch -p1 < ${./use-mysql-over-domain-socket.patch}

      # Workaround for https://github.com/svanderburg/node2nix/issues/275
      sed -i -e "s|#!/usr/bin/env node|#! ${nodejs}/bin/node|" node_modules/node-gyp-build/bin.js

      find . -name package-lock.json -delete
    '';

    postInstall = let
      runtimeDeps = [ nodejs bash ];
    in
    ''
      mkdir -p $out/{bin,libexec,share/doc/epgstation,share/man/man1}

      pushd $out/lib/node_modules/epgstation

      cp -r ${client}/lib/node_modules/epgstation-client/node_modules client/node_modules
      chmod -R u+w client/node_modules

      npm run build

      npm prune --production
      pushd client
      npm prune --production
      popd

      mv config/enc.js.template $out/libexec/enc.js
      mv LICENSE Readme.md $out/share/doc/epgstation
      mv doc/* $out/share/doc/epgstation
      sed 's/@DESCRIPTION@/${drv.meta.description}/g' ${./epgstation.1} \
        | ${gzip}/bin/gzip > $out/share/man/man1/epgstation.1.gz
      rm -rf doc

      # just log to stdout and let journald do its job
      rm -rf logs

      # Replace the existing configuration and runtime state directories with
      # symlinks. Without this, they would all be non-writable because they
      # reside in the Nix store. Note that the source path won't be accessible
      # at build time.
      rm -r config data recorded thumbnail
      ln -sfT /etc/epgstation config
      ln -sfT /var/lib/epgstation data
      ln -sfT /var/lib/epgstation/recorded recorded
      ln -sfT /var/lib/epgstation/thumbnail thumbnail

      makeWrapper ${nodejs}/bin/npm $out/bin/epgstation \
       --chdir "$out/lib/node_modules/epgstation" \
       --prefix PATH : ${lib.makeBinPath runtimeDeps} \
       --set APP_ROOT_PATH "$out/lib/node_modules/epgstation"

      popd
    '';

    # NOTE: this may take a while since it has to update all packages in
    # nixpkgs.nodePackages
    passthru.updateScript = import ./update.nix {
      inherit lib;
      inherit (src.meta) homepage;
      inherit
        pname
        version
        gitUpdater
        writers
        jq
        yq;
    };

    # nodePackages.epgstation is a stub package to fetch npm dependencies and
    # its meta.platforms is made empty to prevent users from installing it
    # directly. This technique ensures epgstation can share npm packages with
    # the rest of nixpkgs while still allowing us to heavily customize the
    # build. It also allows us to provide devDependencies for the epgstation
    # build process without doing the same for all the other node packages.
    meta = drv.meta // {
      inherit (nodejs.meta) platforms;
    };
  });
in
server // {
  name = "${pname}-${version}";

  meta = with lib; server.meta // {
    maintainers = with maintainers; [ midchildan ];

    # NOTE: updateScript relies on this being correct
    position = toString ./default.nix + ":1";
  };
}
