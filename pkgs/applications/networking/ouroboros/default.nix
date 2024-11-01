{ stdenv
, lib
, cmake
, dnsutils
, fetchgit
, fuse
, libgcrypt
, openssl
, pkg-config
, protobuf
, protobufc
, systemd
}:
stdenv.mkDerivation rec {
  pname = "ouroboros";
  version = "0.20.1";
  src = fetchgit {
    url = "git://ouroboros.rocks/${pname}";
    rev = version;
    hash = "sha256-r5IyWEdNDfrJnW8Th+pWvGVFHsxEp91IQomesLNADJI=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    protobufc
    dnsutils
    fuse
    libgcrypt
    openssl
    protobuf
    systemd
  ];
  strictDeps = true;
  cmakeFlags = [ "-DSYSTEMD_UNITDIR=${placeholder "out"}/etc/systemd/system" ];
  meta = {
    description = "A future network prototype descended from RINA";
    homepage = "https://ouroboros.rocks/";
    license = with lib.licenses; [
      lgpl21Only # library
      gpl2Only # daemons
      bsd3 # tools
    ];
    maintainers = with lib.maintainers; [ twey ];
    platforms = lib.platforms.unix;
  };
}
