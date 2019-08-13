{ autoPatchelfHook
, callPackage
, dpkg
, fetchurl
, lib
, stdenv
# Package dependencies
, fuse
, libsearpc
, openssl
, sqlite
}:

let
  # seadrive-daemon gives "no version information available" warnings
  # and runtime errors like
  # "libcurl failed to GET ... SSL peer certificate or SSH remote key was not OK."
  # with nixpkgs curl
  deblibcurl = callPackage ./lib/deblibcurl {};
  # seadrive-daemon specifically looks for libevent-2.0 and fails to build with libevent-2.1
  libevent_2_0 = callPackage ./lib/libevent_2_0 {};
in stdenv.mkDerivation rec {
  version = "1.0.6";
  pname = "seadrive-daemon";

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
    fuse
    libevent_2_0
    libsearpc
    openssl
    sqlite
  ];

  installPhase = ''
    mkdir --parent $out
    mv * $out/
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.seafile.com/en/home/";
    description = "Access files on a Seafile server without syncing to local disk";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
