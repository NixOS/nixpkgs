{
  buildGoModule,
  fetchurl,
  lib,
  zstd,
  sharness,
  python3,
  perl,
}:

buildGoModule (finalAttrs: {
  pname = "goredo";
  version = "2.10.0";

  src = fetchurl {
    url = "http://www.goredo.stargrave.org/download/goredo-${finalAttrs.version}.tar.zst";
    hash = "sha256-kinv+9it0nK0ia8S2W8AN8FWy1dRN9nNzVeG8n4aY2Q=";
  };

  nativeBuildInputs = [ zstd ];

  nativeCheckInputs = [
    python3
    perl
  ];

  env = {
    inherit (sharness) SHARNESS_TEST_SRCDIR;
  };

  vendorHash = null;

  modRoot = "./src";
  subPackages = [ "." ];

  postBuild = ''
    ( cd $GOPATH/bin; ./goredo -symlinks )
    cd ..
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export PATH=$GOPATH/bin:$PATH
    (cd t; prove -f .)
    runHook postCheck
  '';

  postInstall = ''
    mkdir -p "$out/share/info"
    cp goredo.info "$out/share/info"
  '';

  outputs = [
    "out"
    "info"
  ];

  meta = {
    outputsToInstall = [ "out" ];
    description = "Makefile replacement that sucks less";
    homepage = "http://www.goredo.stargrave.org/";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.spacefrogg ];
  };
})
