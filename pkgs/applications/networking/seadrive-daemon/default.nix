{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, curl
, fuse
, libevent
, libsearpc
, openssl_1_1
, sqlite
}:

let
  deblibcurl = callPackage ./deblibcurl {};
in stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "seadrive-daemon";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://deb.seadrive.org/buster/pool/main/s/${pname}/${pname}_${version}_amd64.deb";
    sha256 = "1rhh1s1627w74l2bsw6pmnid7h2rjsii2ng8qhw9wa8q6g1xc0yp";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    deblibcurl
    fuse
    libevent
    libsearpc
    openssl_1_1
    sqlite
  ];

  installPhase = ''
    mkdir --parent $out
    mv * $out/
  '';

  meta = {
    homepage = "https://www.seafile.com/en/home/";
    description = "The SeaDrive client enables you to access files on the Seafile server without syncing to local disk. It works like a network drive.";
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.unfree;
  };
}
