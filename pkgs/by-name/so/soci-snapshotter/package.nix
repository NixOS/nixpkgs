{ lib, buildGoModule, fetchFromGitHub, musl, flatbuffers, pkg-config, zlib }:

buildGoModule rec {
  # note: there is another package called soci - https://soci.sourceforge.net/
  #
  # soci comprises of two binaries: the soci image indexer which is a cli tool
  # and a grpc service for running soci images in a lazy loading manner.

  # this package has a makefile but I found it difficult to use that here
  # so I'm using the more or less standard gomodules build approach - there
  # are a couple of issues:
  # - the go.mod file in the cmd dir imports the module using a relative path
  # - the instructions for cgo to import the zlib library are currently not compatible with pkg-config
  pname = "soci-snapshotter";
  version = "0.5.0";
  # I don't know a nice way to obtain the commit hash when specifying the version and using the fetchFromGithub fetcher
  # this should be updated with the version and is given to the build process as an input so soci --version shows the commit hash
  commitHash = "77f218d";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "soci-snapshotter";
    rev = "v${version}";
    sha256 = "sha256-xcEAe0gzhuvquzqXwPl+ESh1qSP+vLraFV21bfHwDH0=";
  };

  vendorHash = "sha256-wU3nCaQ1/ZrvJt3P9j2IeifD9WV+0YmHrYhwAnn/s0M=";

  # zlib is required for some compression stuff that is used within soci
  buildInputs = [zlib];

  # according to the documentation flatbuffers can be required in the build
  # but usually it is not
  nativeBuildInputs = [musl flatbuffers pkg-config];

  # zlib is a C dependency
  CGO_ENABLED = 1;

  ldflags = [
    "-linkmode external"
    "-extldflags '-static -L${musl}/lib'"
  ];

  modBuildPhase = ''
    runHook preBuild

    cd cmd
    sed -i 's/github.com\/awslabs\/soci-snapshotter v0.0.0 => ..\//github.com\/awslabs\/soci-snapshotter v0.0.0 => github.com\/awslabs\/soci-snapshotter v0.5.0/' go.mod
    sed -i 's/github.com\/awslabs\/soci-snapshotter v0.0.0-local => ..\//github.com\/awslabs\/soci-snapshotter v0.0.0-local => github.com\/awslabs\/soci-snapshotter v0.5.0/' go.mod

    go mod tidy
    go mod vendor

    runHook postBuild
  '';

  buildPhase = ''
    runHook preBuild

    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    mkdir -p $GOPATH/bin

    export REVISION=$(git rev-parse HEAD)$(if ! git diff --no-ext-diff --quiet --exit-code; then echo .m; fi)

    # the go-modules derivation is mounted above where it needs to be mounted for this build
    cp -r vendor cmd/vendor
    cd cmd
    sed -i 's/github.com\/awslabs\/soci-snapshotter v0.0.0 => ..\//github.com\/awslabs\/soci-snapshotter v0.0.0 => github.com\/awslabs\/soci-snapshotter v0.5.0/' go.mod
    sed -i 's/github.com\/awslabs\/soci-snapshotter v0.0.0-local => ..\//github.com\/awslabs\/soci-snapshotter v0.0.0-local => github.com\/awslabs\/soci-snapshotter v0.5.0/' go.mod

    cat go.mod

    ls -al vendor/github.com/awslabs/soci-snapshotter

    chmod 0777 vendor/github.com/awslabs/soci-snapshotter/ztoc/compression/gzip_zinfo.go
    #echo "testing..." > vendor/github.com/awslabs/soci-snapshotter/ztoc/compression/gzip_zinfo.go
    sed 's/#cgo LDFLAGS: -L\''${SRCDIR}\/..\/out -l:libz.a/#cgo pkg-config: zlib/' vendor/github.com/awslabs/soci-snapshotter/ztoc/compression/gzip_zinfo.go > $TMPDIR/gzip_zinfo.go
    cat $TMPDIR/gzip_zinfo.go > vendor/github.com/awslabs/soci-snapshotter/ztoc/compression/gzip_zinfo.go

    echo
    echo "*** Starting soci build..."
    echo
    go build -v -ldflags "-s -w -X github.com/awslabs/soci-snapshotter/version.Version=${version} -X github.com/awslabs/soci-snapshotter/version.Revision=${commitHash}" -o "''${GOPATH}/bin/soci" ./soci
    go build -v -ldflags "-s -w -X github.com/awslabs/soci-snapshotter/version.Version=${version} -X github.com/awslabs/soci-snapshotter/version.Revision=${commitHash}" -o "''${GOPATH}/bin/soci-snapshotter-grpc" ./soci-snapshotter-grpc

    runHook postBuild
  '';

  meta = with lib; {
    description = "A tool to index OCI images to support lazy loading mechanisms.";
    homepage = "https://github.com/awslabs/soci-snapshotter";
    license = licenses.asl20;
    maintainers = with maintainers; [ seanrmurphy ];
    platforms = ["x86_64-linux"];
  };
}
