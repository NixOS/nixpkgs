{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, bash
, nodejs
, gzip
, callPackage
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

  client = nodejs.pkgs.epgstation-client.override (drv: {
    # This is set to false to keep devDependencies at build time. Build time
    # dependencies are pruned afterwards.
    production = false;

    meta = drv.meta // {
      inherit (nodejs.meta) platforms;
    };
  });

  server = nodejs.pkgs.epgstation.override (drv: {
    # NOTE: updateScript relies on version matching the src.
    inherit version src;

    # This is set to false to keep devDependencies at build time. Build time
    # dependencies are pruned afterwards.
    production = false;

    buildInputs = (drv.buildInputs or [ ]) ++ [ bash ];
    nativeBuildInputs = (drv.nativeBuildInputs or [ ]) ++ [
      makeWrapper
    ];

    preRebuild = ''
      # Fix for OpenSSL compat with newer Node.js
      export NODE_OPTIONS=--openssl-legacy-provider

      # Fix for not being able to connect to mysql using domain sockets.
      patch -p1 < ${./use-mysql-over-domain-socket.patch}

      # Workaround for https://github.com/svanderburg/node2nix/issues/275
      sed -i -e "s|#!/usr/bin/env node|#! ${nodejs}/bin/node|" node_modules/node-gyp-build/bin.js

      # Optional typeorm dependency that does not build on aarch64-linux
      rm -r node_modules/oracledb

      find . -name package-lock.json -delete
    '';

    postInstall = let
      runtimeDeps = [ nodejs bash ];
    in
    ''
      mkdir -p $out/{bin,libexec,share/doc/epgstation,share/man/man1}

      pushd $out/lib/node_modules/epgstation

      cp -r ${client}/lib/node_modules/epgstation-client/{package-lock.json,node_modules} client/
      chmod -R u+w client/{package-lock.json,node_modules}

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
    passthru.updateScript = callPackage ./update.nix { };

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
