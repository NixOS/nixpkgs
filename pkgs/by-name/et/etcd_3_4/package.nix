{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.42";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-Ue5Mcksy3LiXLaVdxNz83V9qrxQfzxL5kw4rZobYcvY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-DqKVZ4Z2RMRwi4Z/6Rh3SE6NSyuHePSYrIM7sPyPC74=";

  preBuild = ''
    go mod tidy
  '';

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    ./build
    ./functional/build
    runHook postBuild
  '';

  doCheck = false;

  postInstall = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  passthru.tests = nixosTests.etcd."3_4";

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    downloadPage = "https://github.com/etcd-io/etcd/";
    license = lib.licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with lib.maintainers; [ superherointj ];
  };
}
