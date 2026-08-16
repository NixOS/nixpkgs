{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  cmake,
  libpcap,
}:
stdenv.mkDerivation {
  pname = "packetdrill";
  version = "2.0-unstable-2026-04-29";

  src = fetchFromGitHub {
    owner = "google";
    repo = "packetdrill";
    rev = "faa0dfb54065118625e169d3111ce09c65b20229";
    hash = "sha256-+9qfNT2veOsShj9JvLiBm7i842zFhUiPmrt8QA/ZuKs=";
  };

  setSourceRoot = ''
    export sourceRoot=$(realpath */gtests/net/packetdrill)
  '';

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
