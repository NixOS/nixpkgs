{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bc-ur";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "BlockchainCommons";
    repo = "bc-ur";
    rev = finalAttrs.version;
    hash = "sha256-j7nmAZH1OL7R5H3jqQomg7kwPOvIHMqrfSk7mq/f7Cg=";
  };

  patches = [
    # Fix missing includes, building on gcc13, add CMakeList.txt
    (fetchpatch {
      url = "https://raw.githubusercontent.com/feather-wallet/feather/632963a9e22bf4c8bbe6b5b4d895e31bda17bafd/contrib/depends/patches/bc-ur/build-fix.patch";
      hash = "sha256-F53/z0maUGfdzJ7qjcLjTzn6+80oxu4sqfQPsDo4HZ0=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://github.com/BlockchainCommons/bc-ur";
    description = "UR reference library in C++";
    license = licenses.bsd2Patent;
    maintainers = with maintainers; [ surfaceflinger ];
    platforms = platforms.linux;
  };
})
