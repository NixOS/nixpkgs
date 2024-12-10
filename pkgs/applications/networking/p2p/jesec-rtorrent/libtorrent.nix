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
  version = "0.13.8-r4";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "libtorrent";
    rev = "v${version}";
    hash = "sha256-jC/hgGSi2qy+ToZgdxl1PhASLYbUL0O8trX0th2v5H0=";
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
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code (jesec's fork)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      winter
      AndersonTorres
    ];
    platforms = platforms.linux;
  };
}
