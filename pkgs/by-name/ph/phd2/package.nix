{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  cfitsio,
  curl,
  eigen_3_4_0,
  gettext,
  glib,
  gtest,
  gtk3,
  libnova,
  libusb1,
  wxGTK32,
}:

stdenv.mkDerivation rec {
  pname = "phd2";
  version = "2.6.13";

  src = fetchFromGitHub {
    owner = "OpenPHDGuiding";
    repo = "phd2";
    rev = "v${version}";
    sha256 = "sha256-GnT/tyk975caqESBSu4mdX5IWGi5O+RljLSd+CwoGWo=";
  };

  # fixes build error because of missing include
  # is in masster, should be removed with next release
  patches = [
    (fetchpatch2 {
      url = "https://github.com/OpenPHDGuiding/phd2/commit/0927de6c8943fae7161457008b989bf72a05c638.patch?full_index=1";
      hash = "sha256-yo5YdZ4B7jx6p4TqFZc7RJsutsWzeNBUfinFAd8es7E=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cfitsio
    curl
    eigen_3_4_0
    gettext
    glib
    gtest
    gtk3
    libnova
    libusb1
    wxGTK32
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=17" # needed for gtest
    "-DOPENSOURCE_ONLY=1"
    "-DUSE_SYSTEM_CFITSIO=ON"
    "-DUSE_SYSTEM_LIBUSB=ON"
    "-DUSE_SYSTEM_EIGEN3=ON"
    "-DUSE_SYSTEM_GTEST=ON"
  ];

  # Fix broken wrapped name scheme by moving wrapped binary to where wrapper expects it
  postFixup = ''
    mv $out/bin/.phd2.bin-wrapped $out/bin/.phd2-wrapped.bin
  '';

  meta = {
    homepage = "https://openphdguiding.org/";
    description = "Telescope auto-guidance application";
    changelog = "https://github.com/OpenPHDGuiding/phd2/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      returntoreality
    ];
    platforms = lib.platforms.linux;
  };
}
