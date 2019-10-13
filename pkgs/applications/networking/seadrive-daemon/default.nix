{ autoPatchelfHook
, callPackage
, fetchurl
, lib
, rpmextract
, stdenv
# Package dependencies
, curl
, fuse
, libsearpc
, openssl
, sqlite
}:

let
  # seadrive-daemon specifically looks for libevent-2.0 and fails to build with libevent-2.1
  libevent_2_0 = callPackage ./lib/libevent_2_0 {};
in stdenv.mkDerivation rec {
  version = "1.0.7";
  pname = "seadrive-daemon";

  src = fetchurl {
    url = "https://rpm.seadrive.org/centos7/${pname}_${version}_x86_64.rpm";
    sha256 = "0c4am8jcjpgh47pag88bf01s77dfyfg3vssv33lm85d68a6mssl7";
  };

  unpackCmd = "${rpmextract}/bin/rpmextract $src";

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    curl
    fuse
    libevent_2_0
    libsearpc
    sqlite
  ];

  installPhase = ''
    mkdir --parent $out
    mv * $out/

    # seadrive-daemon looks for 'libssl.so.10' and 'libcrypto.so.10'
    mkdir $out/lib
    ln -s ${lib.getLib openssl}/lib/libssl.so.1.0.0 $out/lib/libssl.so.10
    ln -s ${lib.getLib openssl}/lib/libcrypto.so.1.0.0 $out/lib/libcrypto.so.10
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.seafile.com/en/home/";
    description = "Access files on a Seafile server without syncing to local disk";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ justinlovinger ];
  };
}
