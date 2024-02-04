{ lib, pkgs, stdenv, buildGoModule, fetchFromGitHub, testers, autoPatchelfHook, kluctl }:

buildGoModule rec {
  pname = "kluctl";
  version = "2.23.1";

  src = fetchFromGitHub {
    owner = "netthier";
    repo = "kluctl";
    #rev = "v${version}";
    rev = "go-embed-py-patch";
    hash = "sha256-V6qZqWvMXOcRW0vKUgcg1jIdt/W2HAlpfOxfEMhP3e0=";
  };

  subPackages = [ "cmd" ];

  vendorHash = "sha256-E8RDDRWJmzVxmVA1ssRJd+tscjf7bJLiB/OhzDpRJ5o=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}" ];

  # Depends on docker
  doCheck = false;

  nativeBuildInputs = [
    autoPatchelfHook
    pkgs.libxcrypt-legacy
  ];

  buildInputs = with pkgs; [
    libxcrypt-legacy
  ];

  passthru.tests.version = testers.testVersion {
    package = kluctl;
    version = "v${version}";
  };

  modPostBuild = ''
    PREPARE_PATH=$(mktemp -d)
    cd vendor/github.com/kluctl/go-embed-python
    go run -mod=mod github.com/kluctl/go-embed-python/python/generate --python-version=3.11.6 --python-standalone-version=20231002 --pack=false --prepare-path=$PREPARE_PATH
    autoPatchelf $PREPARE_PATH
    go run -mod=mod github.com/kluctl/go-embed-python/python/generate --python-version=3.11.6 --python-standalone-version=20231002 --prepare=false --prepare-path=$PREPARE_PATH
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
