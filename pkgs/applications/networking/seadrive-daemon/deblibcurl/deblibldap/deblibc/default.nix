{ autoPatchelfHook
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
}:

stdenv.mkDerivation rec {
  version = "6.2.28";
  pname = "deblibc";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6_2.28-10_amd64.deb";
    sha256 = "0yas35kmdxwax2v628hm9zc15px11qc0178m6f34ynaz30kkww3g";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc ./out";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [ ];

  # Lib files need to be in $out/lib for autoPatchelfHook and other to find
  installPhase = ''
    mkdir --parent $out
    mv * $out/
    mv $out/lib/x86_64-linux-gnu/* $out/lib/
    mv $out/lib64/* $out/lib/
  '';

  meta = {
    homepage = "https://packages.debian.org/buster/libc6";
    description = "GNU C Library: Shared libraries";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
