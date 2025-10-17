{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cli11,
  gtest,
  libcap,
  libseccomp,
  nlohmann_json,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linyaps-box";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "OpenAtom-Linyaps";
    repo = "linyaps-box";
    rev = finalAttrs.version;
    hash = "sha256-h7tbjIcVgwTw3SLGzJzG17WpDdsCqHD4AXvAFEiwesw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cli11
    gtest
    libcap
    libseccomp
    nlohmann_json
  ];

  cmakeFlags = [
    (lib.cmakeBool "linyaps-box_ENABLE_SECCOMP" true)
  ];

  meta = {
    description = "Simple OCI runtime mainly used by linyaps";
    homepage = "https://github.com/OpenAtom-Linyaps/linyaps-box";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ll-box";
    maintainers = with lib.maintainers; [ wineee ];
  };
})
