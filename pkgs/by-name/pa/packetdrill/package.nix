{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  bison,
  flex,
  cmake,
  libpcap,
}:
stdenv.mkDerivation {
  pname = "packetdrill";
  version = "unstable-2020-08-22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "packetdrill";
    rev = "68a34fa73cf221e5f52d6fa4f203bcd93062be1b";
    sha256 = "0djkwb6l2959f44d98vwb092rghf0qmii8391vrpxqb99j6pv4h6";
  };
  patches = [
    # Upstream fix for -fno-common toolchains
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/google/packetdrill/commit/c08292838de81a71ee477d5bf9d95b1130a1292b.patch";
      sha256 = "1irbar1zkydmgqb12r3xd80dwj2jfxnxayxpb4nmbma8xm7knb10";
      stripLen = 3;
    })
  ];

  setSourceRoot = ''
    export sourceRoot=$(realpath */gtests/net/packetdrill)
  '';

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=unused-result"
    "-Wno-error=stringop-truncation"
    "-Wno-error=address-of-packed-member"
  ];
  nativeBuildInputs = [
    bison
    flex
    cmake
    libpcap
  ];
  buildInputs = [ libpcap ];

  installPhase = ''
    install -m 0755 -t $out/bin -D \
      packetdrill \
      packet_parser_test \
      packet_to_string_test \
      checksum_test
    mkdir -p $out/share
    cp -r ../tests $out/share/packetdrill-tests
  '';

  meta = {
    description = "Quick, precise tests for entire TCP/UDP/IPv4/IPv6 network stacks";
    homepage = "https://github.com/google/packetdrill";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      dmjio
      cleverca22
    ];
  };
}
