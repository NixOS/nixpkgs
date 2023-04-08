{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, gtest
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "UHDM";
  version = "1.45";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mxQRmI8yUUrSUYa4kUT9URgfqYvuz3V9e1IGjtiHyhc=";
    fetchSubmodules = true;
  };

  # Add ability to use local googletest provided from nix instead of
  # the version from the submodule in third_party/. The third_party/ version
  # is slightly older and does not work with our hydra Darwin builds that needs
  # to set a particular temp directory.
  # This patch allows to choose UHDM_USE_HOST_GTEST=On in the cflags.
  patches = [
    (fetchpatch {
      url = "https://github.com/chipsalliance/UHDM/commit/ad60fdb65a7c49fdc8ee3fffdca791f9364af4f5.patch";
      sha256 = "sha256-IkwnepWWmBychJ0mu+kaddUEc9jkldIRq+GyJkhrO8A=";
      name = "allow-local-gtest.patch";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    (python3.withPackages (p: with p; [ orderedmultidict ]))
    gtest
  ];

  cmakeFlags = [
    "-DUHDM_USE_HOST_GTEST=On"
  ];

  doCheck = true;
  checkPhase = "make test";

  postInstall = ''
    mv $out/lib/uhdm/* $out/lib/
    rm -rf $out/lib/uhdm
  '';

  meta = {
    description = "Universal Hardware Data Model";
    homepage = "https://github.com/chipsalliance/UHDM";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
