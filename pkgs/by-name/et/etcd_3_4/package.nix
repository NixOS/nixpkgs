{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "etcd";
  version = "3.4.45";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GvhejN7+woYK7UBNguzEaO6rqAbT7Vbwl5nFmI/F6Sc=";
  };

  proxyVendor = true;
  vendorHash = "sha256-0xIK71sAwMzzSaN2lFKKdGtDKWYtL25x5GDoO6bO0wI=";

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
})
