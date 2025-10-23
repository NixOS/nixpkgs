{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libsForQt5,
  zlib,
  openjpeg,
  libjpeg_turbo,
  libpng,
  libtiff,
  boost,
  libcanberra,
}:

stdenv.mkDerivation rec {
  pname = "scantailor-universal";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "trufanov-nok";
    repo = "scantailor-universal";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-n8NbokK+U0FAuYXtjRJcxlI1XAmI4hk5zV3sF86hB/s=";
  };

  patches = [
    # Bump CMAKE_MINIMUM_REQUIRED
    (fetchpatch {
      url = "https://github.com/trufanov-nok/scantailor-universal/commit/f90b1c6bb2954ca5c4d0c5b310f359c522fe538c.patch?full_index=1";
      hash = "sha256-c/mynpM4XNbQ6TcxzZvwwujnfwwA1TPogNU9393gcY4=";
    })
    # Remove outdated CMP0043 policy
    (fetchpatch {
      url = "https://github.com/trufanov-nok/scantailor-universal/commit/248fdf0fc2dc014d76d4ec9e27a7ad340ff7aaf5.patch?full_index=1";
      hash = "sha256-xK0hNr6YHgMK4fghc07CTRwcsizTsnGSdDwqcUf9wsY=";
    })

  ];

  buildInputs = [
    libsForQt5.qtbase
    zlib
    libjpeg_turbo
    libpng
    libtiff
    boost
    libcanberra
    openjpeg
  ];
  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  meta = with lib; {
    description = "Interactive post-processing tool for scanned pages";
    homepage = "https://github.com/trufanov-nok/scantailor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ unclamped ];
    platforms = platforms.unix;
    mainProgram = "scantailor-universal-cli";
  };
}
