{ autoPatchelfHook
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
}:

stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "deblibsasl";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.27+dfsg-1_amd64.deb";
    sha256 = "0mdn1r4gz6dmx51fm8pqwdrh5k9djrvy6dhv18ia4xn4jfqnz1ym";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [ ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    cp $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/buster/libsasl2-2";
    description = "Cyrus SASL - authentication abstraction library";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.bsdOriginal;
  };
}
