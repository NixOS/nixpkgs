{ lib
, buildEnv
, makeWrapper
, kubo-migrator-unwrapped
, kubo-migrator-all-fs-repo-migrations
}:

buildEnv {
  name = "kubo-migrator-${kubo-migrator-unwrapped.version}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [ kubo-migrator-unwrapped ];

  pathsToLink = [ "/bin" ];

  postBuild = ''
    wrapProgram "$out/bin/fs-repo-migrations" \
      --prefix PATH ':' '${lib.makeBinPath [ kubo-migrator-all-fs-repo-migrations ]}'
  '';

  inherit (kubo-migrator-unwrapped) meta;
}
