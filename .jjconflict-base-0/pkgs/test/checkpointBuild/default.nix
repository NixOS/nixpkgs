{ hello, checkpointBuildTools, runCommand, texinfo, stdenv, rsync }:
let
  baseHelloArtifacts = checkpointBuildTools.prepareCheckpointBuild hello;
  patchedHello = hello.overrideAttrs (old: {
    buildInputs = [ texinfo ];
    src = runCommand "patch-hello-src" { } ''
      mkdir -p $out
      cd $out
      tar xf ${hello.src} --strip-components=1
      patch -p1 < ${./hello.patch}
    '';
  });
  checkpointBuiltHello = checkpointBuildTools.mkCheckpointBuild patchedHello baseHelloArtifacts;

  checkpointBuiltHelloWithCheck = checkpointBuiltHello.overrideAttrs (old: {
    doCheck = true;
    checkPhase = ''
      echo "checking if unchanged source file is not recompiled"
        [ "$(stat --format="%Y" lib/exitfail.o)" = "$(stat --format="%Y" ${baseHelloArtifacts}/outputs/lib/exitfail.o)" ]
    '';
  });

  baseHelloRemoveFileArtifacts = checkpointBuildTools.prepareCheckpointBuild (hello.overrideAttrs (old: {
    patches = [ ./hello-additionalFile.patch ];
  }));

  preparedHelloRemoveFileSrc = runCommand "patch-hello-src" { } ''
    mkdir -p $out
    cd $out
    tar xf ${hello.src} --strip-components=1
    patch -p1 < ${./hello-additionalFile.patch}
  '';

  patchedHelloRemoveFile = hello.overrideAttrs (old: {
    buildInputs = [ texinfo ];
    src = runCommand "patch-hello-src" { } ''
      mkdir -p $out
      cd $out
      ${rsync}/bin/rsync -cutU --chown=$USER:$USER --chmod=+w -r ${preparedHelloRemoveFileSrc}/* .
      patch -p1 < ${./hello-removeFile.patch}
    '';
  });

  checkpointBuiltHelloWithRemovedFile = checkpointBuildTools.mkCheckpointBuild patchedHelloRemoveFile baseHelloRemoveFileArtifacts;
in
stdenv.mkDerivation {
  name = "patched-hello-returns-correct-output";
  buildCommand = ''
    touch $out

    echo "testing output of hello binary"
    [ "$(${checkpointBuiltHelloWithCheck}/bin/hello)" = "Hello, incremental world!" ]
    echo "testing output of hello with removed file"
    [ "$(${checkpointBuiltHelloWithRemovedFile}/bin/hello)" = "Hello, incremental world!" ]
  '';
}

