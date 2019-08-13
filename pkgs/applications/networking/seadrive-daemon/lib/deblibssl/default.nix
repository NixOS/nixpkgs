{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
}:

stdenv.mkDerivation rec {
  version = "1.0.2";
  pname = "deblibssl";

  src = fetchurl {
    url = "http://security.debian.org/debian-security/pool/updates/main/o/openssl1.0/libssl1.0.2_1.0.2s-1~deb9u1_amd64.deb";
    sha256 = "0g3zkmrbiq6dgn16kmm70dgnh16mlfj3r8kpmivf5sggmh9b6228";
    name = "libssl1.0.2_1.0.2s-1-deb9u1_amd64.deb";
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
    homepage = "https://packages.debian.org/stretch/libssl1.0.2";
    description = "Secure Sockets Layer toolkit - shared libraries";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.openssl;
  };
}
