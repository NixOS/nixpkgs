{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  nixosTests,
}:

buildGo124Module rec {
  pname = "etcd";
  version = "3.4.39";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    hash = "sha256-S1aNEd7pPgSu8vFhXIYFjEvfBG3OtmuKCvD5Zgj0m30=";
  };

  proxyVendor = true;
  vendorHash = "sha256-CqeSRyWDw1nCKlAI46iJXT5XjI3elxufx87QIlHwp1w=";

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
    maintainers = [ ];
  };
}
