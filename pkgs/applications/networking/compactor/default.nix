{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  asciidoctor,
  autoreconfHook,
  pkg-config,
  boost186,
  libctemplate,
  libmaxminddb,
  libpcap,
  libtins,
  openssl,
  protobuf,
  xz,
  zlib,
  catch2,
  cbor-diag,
  cddl,
  diffutils,
  file,
  mktemp,
  netcat,
  tcpdump,
  wireshark-cli,
}:

stdenv.mkDerivation rec {
  pname = "compactor";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "dns-stats";
    repo = "compactor";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-5Z14suhO5ghhmZsSj4DsSoKm+ct2gQFO6qxhjmx4Xm4=";
  };

  patches = [
    ./patches/add-a-space-after-type-in-check-response-opt-sh.patch

    # https://github.com/dns-stats/compactor/pull/91
    ./patches/update-golden-cbor2diag-output.patch

    # https://github.com/dns-stats/compactor/commit/f7deaf89f55a12c586b6662a3a7d04b10a4c7bcb
    (fetchpatch {
      url = "https://github.com/dns-stats/compactor/commit/f7deaf89f55a12c586b6662a3a7d04b10a4c7bcb.patch";
      hash = "sha256-eEaVS5rfrLkRGc668PwVfb/xw3n1SoCm30xEf1NjbeY=";
    })
  ];

  nativeBuildInputs = [
    asciidoctor
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    boost186
    libctemplate
    libmaxminddb
    libpcap
    libtins
    openssl
    protobuf
    xz
    zlib
  ];

  postPatch = ''
    patchShebangs test-scripts/
    cp ${catch2}/include/catch2/catch.hpp tests/catch.hpp
  '';

  preConfigure = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  configureFlags = [
    "--with-boost-libdir=${boost186.out}/lib"
    "--with-boost=${boost186.dev}"
  ];
  enableParallelBuilding = true;
  enableParallelInstalling = false; # race conditions when installing

  doCheck = !stdenv.hostPlatform.isDarwin; # check-dnstap.sh failing on Darwin
  nativeCheckInputs = [
    cbor-diag
    cddl
    diffutils
    file
    mktemp
    netcat
    tcpdump
    wireshark-cli
  ];

  meta = {
    description = "Tools to capture DNS traffic and record it in C-DNS files";
    homepage = "https://dns-stats.org/";
    changelog = "https://github.com/dns-stats/compactor/raw/${version}/ChangeLog.txt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fdns ];
    platforms = lib.platforms.unix;
  };
}
