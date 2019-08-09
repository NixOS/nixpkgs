{ autoPatchelfHook
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
}:

stdenv.mkDerivation rec {
  version = "2.1.27";
  pname = "deblibsasl";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.27~101-g0780600+dfsg-3_amd64.deb";
    sha256 = "1vd49bwng8pz0dn7aqry6hr26ymp7bmpcih8fl2vdmjp4916vjjz";
    name = "libsasl2-2_2.1.27-101-g0780600+dfsg-3_amd64.deb";
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
    mv $out/lib/x86_64-linux-gnu/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/stretch/libsasl2-2";
    description = "Cyrus SASL - authentication abstraction library";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.bsdOriginal;
  };
}
