{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, fuse
, libsearpc
, sqlite
}:

let
  deblibcurl = callPackage ./lib/deblibcurl {};
  deblibssl = callPackage ./lib/deblibssl {};
  libevent_2_0 = callPackage ./lib/libevent_2_0 {};
in stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "seadrive-daemon";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://deb.seadrive.org/stretch/pool/main/s/${pname}/${pname}_${version}_amd64.deb";
    sha256 = "0y1il9wx9bck6zp8pmjyjws4xvaj0bwlnw1prlgfwvjzv731i6rc";
  };

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $curSrc .";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    deblibcurl
    deblibssl
    fuse
    libevent_2_0
    libsearpc
    sqlite
  ];

  installPhase = ''
    mkdir --parent $out
    mv * $out/
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.seafile.com/en/home/";
    description = "Enables you to access files on the Seafile server without syncing to local disk. It works like a network drive";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
