{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  gtest,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "libnop";
  version = "0-unstable-2021-11-02";

  src = fetchFromGitHub {
    owner = "google";
    repo = "libnop";
    rev = "35e800d81f28c632956c5a592e3cbe8085ecd430";
    hash = "sha256-wt88E3XLKQVUetKI4nMxQDP34iHSJj8bwBGTgiVVC2M=";
  };

  patches = [
    # Adds cmake support
    (fetchpatch {
      url = "https://github.com/google/libnop/commit/5a66ba96d0b3d93afc4164a8a9c71949f4cee64f.patch";
      hash = "sha256-6RZ7j+dLy9o/6YuLkQFKBHspFGTP5KkxaLRHlap5dN0=";
    })
    (fetchpatch {
      url = "https://github.com/google/libnop/commit/83967ad391a30d8f871d57777a91ebd7f9370ad4.patch";
      hash = "sha256-rRwTZSaz2hHyAjaisQ7ljg1LE6T+4yC9zpo9krAAWz4=";
    })
    (fetchpatch {
      url = "https://github.com/google/libnop/commit/149883367057c02b07abc76608f483adb2147403.patch";
      hash = "sha256-/QGYVpJ89dztJLWrgK0wcLZwPtRfMGNe2d8uE9cAZ/4=";
    })
    (fetchpatch {
      url = "https://github.com/google/libnop/commit/2f19ad3ff3b40a323fa6777cb0b7594202769a72.patch";
      hash = "sha256-4GyRdvJbMOz8/OoGR8AS9UblK1Z4EUS9dWZT2UGiRWc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ gtest ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A header-only library for serializing and deserializing C++ data types";
    homepage = "https://github.com/google/libnop";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 tmayoff ];
  };
}
