{ stdenv, go, docker, nixosTests }:

stdenv.mkDerivation {
  name = "tarsum";

  nativeBuildInputs = [ go ];
  disallowedReferences = [ go ];

  dontUnpack = true;

  CGO_ENABLED = 0;
  GOFLAGS = "-trimpath";
  GO111MODULE = "off";

  buildPhase = ''
    runHook preBuild
    mkdir tarsum
    cd tarsum
    cp ${./tarsum.go} tarsum.go
    export GOPATH=$(pwd)
    export GOCACHE="$TMPDIR/go-cache"
    mkdir -p src/github.com/docker/docker/pkg
    ln -sT ${docker.moby-src}/pkg/tarsum src/github.com/docker/docker/pkg/tarsum
    go build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp tarsum $out/bin/
    runHook postInstall
  '';

  passthru = {
    tests = {
      dockerTools = nixosTests.docker-tools;
    };
  };

  meta.platforms = go.meta.platforms;
  meta.mainProgram = "tarsum";
}
