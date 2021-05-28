{ stdenv, fetchFromGitHub, makeWrapper, bash, nodejs, nodePackages, gzip }:

let
  workaround-opencollective-buildfailures = stdenv.mkDerivation {
    # FIXME: This should be removed when a complete fix is available
    # https://github.com/svanderburg/node2nix/issues/145
    name = "workaround-opencollective-buildfailures";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      touch $out/bin/opencollective-postinstall
      chmod +x $out/bin/opencollective-postinstall
    '';
  };
in
nodePackages.epgstation.override (drv: {
  src = fetchFromGitHub {
    owner = "l3tnun";
    repo = "EPGStation";
    rev = "v${drv.version}"; # version specified in ./generate.sh
    sha256 = "15z1kdbamj97frp3dfnbm0h8krihmv2xdab4id0rxin29ibrw1k2";
  };

  buildInputs = [ bash ];
  nativeBuildInputs = [
    workaround-opencollective-buildfailures
    makeWrapper
    nodePackages.node-pre-gyp
  ];

  preRebuild = ''
    # Fix for not being able to connect to mysql using domain sockets.
    patch -p1 ${./use-mysql-over-domain-socket.patch}
  '';

  postInstall = let
    runtimeDeps = [ nodejs bash ];
  in
  ''
    mkdir -p $out/{bin,libexec,share/doc/epgstation,share/man/man1}

    pushd $out/lib/node_modules/EPGStation

    npm run build
    npm prune --production

    mv config/{enc.sh,enc.js} $out/libexec
    mv LICENSE Readme.md $out/share/doc/epgstation
    mv doc/* $out/share/doc/epgstation
    sed 's/@DESCRIPTION@/${drv.meta.description}/g' ${./epgstation.1} \
      | ${gzip}/bin/gzip > $out/share/man/man1/epgstation.1.gz
    rm -rf doc

    # just log to stdout and let journald do its job
    rm -rf logs

    # Replace the existing configuration and runtime state directories with
    # symlinks. Without this, they would all be non-writable because they reside
    # in the Nix store. Note that the source path won't be accessible at build
    # time.
    rm -r config data recorded thumbnail
    ln -sfT /etc/epgstation config
    ln -sfT /var/lib/epgstation data
    ln -sfT /var/lib/epgstation/recorded recorded
    ln -sfT /var/lib/epgstation/thumbnail thumbnail

    makeWrapper ${nodejs}/bin/npm $out/bin/epgstation \
     --run "cd $out/lib/node_modules/EPGStation" \
     --prefix PATH : ${stdenv.lib.makeBinPath runtimeDeps}

    popd
  '';

  meta = with stdenv.lib; drv.meta // {
    maintainers = with maintainers; [ midchildan ];

    # nodePackages.epgstation is a stub package to fetch npm dependencies and
    # is marked as broken to prevent users from installing it directly. This
    # technique ensures epgstation can share npm packages with the rest of
    # nixpkgs while still allowing us to heavily customize the build. It also
    # allows us to provide devDependencies for the epgstation build process
    # without doing the same for all the other node packages.
    broken = false;
  };
})
