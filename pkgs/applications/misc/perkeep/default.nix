{ stdenv, lib, go_1_8, fetchzip, git }:

stdenv.mkDerivation rec {
  name = "perkeep-${version}";
  version = "20170505";

  src = fetchzip {
    url = "https://perkeep.org/dl/monthly/camlistore-${version}-src.zip";
    sha256 = "1vliyvkyzmhdi6knbh8rdsswmz3h0rpxdpq037jwbdbkjccxjdwa";
  };

  buildInputs = [ git go_1_8 ];

  goPackagePath = "";
  buildPhase = ''
    go run make.go
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A way of storing, syncing, sharing, modelling and backing up content (née Camlistore)";
    homepage = https://perkeep.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
