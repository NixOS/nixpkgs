{ lib, pkgs, stdenv, buildGoModule, fetchFromGitHub, testers, autoPatchelfHook, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.23.4";

  src = fetchFromGitHub {
    owner = "kluctl";
    repo = "kluctl";
    rev = "v${version}";
    hash = "sha256-3Jsh/BZ9InZcZMyfotLUG1kqBhGlaMRljpPf6PXGOT4=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  # Depends on docker
  doCheck = false;

  buildInputs = [
    pkgs.libxcrypt-legacy
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    pkgs.libxcrypt-legacy
  ];

  dontAutoPatchelf = "true";

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

  modPostBuild = ''
    PREPARE_PATH=$(mktemp -d)
    cd vendor/github.com/kluctl/go-embed-python
    source python/internal/data/PYTHON_VERSION
    go run -mod=mod github.com/kluctl/go-embed-python/python/generate --python-version=$PYTHON_VERSION --python-standalone-version=$PYTHON_STANDALONE_VERSION --pack=false --prepare-path=$PREPARE_PATH
    autoPatchelf $PREPARE_PATH
    find $PREPARE_PATH -exec touch -t 197001010000.01 {} \;
    go run -mod=mod github.com/kluctl/go-embed-python/python/generate --python-version=$PYTHON_VERSION --python-standalone-version=$PYTHON_STANDALONE_VERSION --prepare=false --prepare-path=$PREPARE_PATH
    rm -rf $PREPARE_PATH
    cd ../../../..
  '';


  postInstall = ''
    mv $out/bin/{cmd,kluctl}
  '';

  meta = with lib; {
    description = "The missing glue to put together large Kubernetes deployments";
    homepage = "https://kluctl.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir netthier ];
  };
}
