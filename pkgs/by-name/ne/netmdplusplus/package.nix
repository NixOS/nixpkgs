{
  cmake,
  fetchFromGitHub,
  lib,
  libgpg-error,
  libgcrypt,
  libusb1,
  stdenv,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "netmdplusplus";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "Jo2003";
    repo = "netmd_plusplus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-niDt7q6NOhiPTGYkiOfVxPZeHJ5ErDBlgJO+HKsZ+Dk=";
  };

  buildInputs = [
    libgcrypt
    libgpg-error
    libusb1
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # https://github.com/NixOS/nixpkgs/issues/144170
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "C++ library for transferring audio to NetMD";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/Jo2003/netmd_plusplus";
    maintainers = with lib.maintainers; [ ddelabru ];
    pkgConfigModules = [
      "libnetmd++"
    ];
    platforms = lib.platforms.all;
  };
})
