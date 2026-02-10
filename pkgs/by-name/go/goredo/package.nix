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
  version = "2.6.0";

  src = fetchurl {
    url = "http://www.goredo.cypherpunks.ru/download/goredo-${finalAttrs.version}.tar.zst";
    hash = "sha256-XTL/otfCKC55TsUBBVors2kgFpOFh+6oekOOafOhcUs=";
  };

  patches = [
    # Adapt tests to Linux/nix-build requirements:
    ./fix-tests.diff
  ];

  nativeBuildInputs = [ zstd ];

  nativeCheckInputs = lib.optionals finalAttrs.doCheck [
    python3
    perl
  ];

  inherit (sharness) SHARNESS_TEST_SRCDIR;

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
    homepage = "https://www.goredo.cypherpunks.ru";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.spacefrogg ];
  };
})
