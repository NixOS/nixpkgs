{ stdenv
, lib

, cmake
, dnsutils
, fetchgit
, fuse
, libgcrypt
, pkgconfig
, protobuf
, protobufc
, systemd
}:
stdenv.mkDerivation rec {
  pname = "ouroboros";
  version = "0.19.3";
  src = fetchgit {
    url = "git://ouroboros.rocks/${pname}";
    rev = version;
    hash = "sha256-DYkQHmfAOxoCA6AqIunHgx7SbeRxpwlPT7ztRzLgv10=";
  };
  buildInputs = [
    cmake
    dnsutils
    fuse
    libgcrypt
    pkgconfig
    protobuf
    protobufc
    systemd
  ];
  cmakeFlags = [ "-DSYSTEMD_UNITDIR=${placeholder "out"}/etc/systemd/system" ];
  meta = {
    description = "A future network prototype descended from RINA";
    homepage = https://ouroboros.rocks/;
    license = with lib.licenses; [
      lgpl21 # library
      gpl2 # daemons
      bsd3 # tools
    ];
    maintainers = with lib.maintainers; [ twey ];
    platforms = lib.platforms.unix;
  };
}
