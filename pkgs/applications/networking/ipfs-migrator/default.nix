{ lib
, buildEnv
, makeWrapper
, ipfs-migrator-unwrapped
, ipfs-migrator-all-fs-repo-migrations
}:

buildEnv {
  name = "ipfs-migrator-${ipfs-migrator-unwrapped.version}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [ ipfs-migrator-unwrapped ];

  pathsToLink = [ "/bin" ];

  postBuild = ''
    wrapProgram "$out/bin/fs-repo-migrations" \
      --prefix PATH ':' '${lib.makeBinPath [ ipfs-migrator-all-fs-repo-migrations ]}'
  '';

  inherit (ipfs-migrator-unwrapped) meta;
}
