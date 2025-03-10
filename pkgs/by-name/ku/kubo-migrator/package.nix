{
  lib,
  buildEnv,
  makeWrapper,
  kubo-migrator-unwrapped,
  kubo-fs-repo-migrations,
}:

buildEnv {
  name = "kubo-migrator-${kubo-migrator-unwrapped.version}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [ kubo-migrator-unwrapped ];

  pathsToLink = [ "/bin" ];

  postBuild = ''
    wrapProgram "$out/bin/fs-repo-migrations" \
      --prefix PATH ':' '${lib.makeBinPath [ kubo-fs-repo-migrations ]}'
  '';

  meta = kubo-migrator-unwrapped.meta // {
    description = "Run the appropriate migrations for migrating the filesystem repository of Kubo";
  };
}
