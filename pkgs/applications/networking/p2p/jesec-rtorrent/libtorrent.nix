{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtest,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "jesec-libtorrent";
  version = "0.13.8-r4-unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "libtorrent";
    rev = "35d844d4d78a671f8840fe6ae973ebb39a0e8f34";
    hash = "sha256-H2oUW9iC2pIUSmP9j0U4RfzO1uiIEWVmeZAfF3Ca48k=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
    zlib
  ];

  # Disabled because a test is flaky; see https://github.com/jesec/libtorrent/issues/4.
  # doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD
  '';

  nativeCheckInputs = [
    gtest
  ];

  meta = with lib; {
    homepage = "https://github.com/jesec/libtorrent";
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code (jesec's fork)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ winter ];
    platforms = platforms.linux;
  };
}
