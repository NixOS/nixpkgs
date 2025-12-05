{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fuse3,
  mbedtls,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dislocker";
  version = "0.7.3-unstable-2025-09-07";

  src = fetchFromGitHub {
    owner = "Aorimn";
    repo = "dislocker";
    rev = "4ff070f0ea9e56948ab316fb76b91f54dd6727aa";
    hash = "sha256-hrIt5D9YjBWs0Q9chWGQM2bo1SZ7qLCd898zFHWWcqA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fuse3
    mbedtls
  ];

  meta = {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage = "https://github.com/Aorimn/dislocker";
    changelog = "https://github.com/Aorimn/dislocker/raw/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      elitak
      yuannan
    ];
    platforms = lib.platforms.unix;
  };
})
