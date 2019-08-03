{ buildGo110Package, fetchzip, lib }:

buildGo110Package rec {
  name = "perkeep-${version}";
  version = "0.10.1";

  src = fetchzip {
    url = "https://perkeep.org/dl/perkeep-${version}-src.zip";
    sha256 = "0rqibc6w4m1r50i2pjcgz1k9dxh18v7jwj4s29y470bc526wv422";
  };

  goPackagePath = "perkeep.org";

  buildPhase = ''
    cd "$NIX_BUILD_TOP/go/src/$goPackagePath"
    go run make.go
  '';

  # devcam is only useful when developing perkeep, we should not install it as
  # part of this derivation.
  postInstall = ''
    rm -f $out/bin/devcam
  '';

  meta = with lib; {
    description = "A way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = https://perkeep.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan kalbasit ];
    platforms = platforms.unix;
  };
}
