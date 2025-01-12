{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  mbedtls_2,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "dislocker";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "aorimn";
    repo = "dislocker";
    rev = "v${version}";
    sha256 = "1ak68s1v5dwh8y2dy5zjybmrh0pnqralmyqzis67y21m87g47h2k";
  };

  patches = [
    # This patch
    #   1. adds support for the latest FUSE on macOS
    #   2. uses pkg-config to find libfuse instead of searching in predetermined
    #      paths
    #
    # https://github.com/Aorimn/dislocker/pull/246
    (fetchpatch {
      url = "https://github.com/Aorimn/dislocker/commit/7744f87c75fcfeeb414d0957771042b10fb64e62.diff";
      sha256 = "0bpyccbbfjsidsrd2q9qylb95nvi8g3glb3jss7xmhywj86bhzr5";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    fuse
    mbedtls_2
  ];

  meta = with lib; {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage = "https://github.com/aorimn/dislocker";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elitak ];
    platforms = platforms.unix;
  };
}
