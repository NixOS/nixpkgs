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
  systemdLibs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linyaps-box";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "OpenAtom-Linyaps";
    repo = "linyaps-box";
    rev = finalAttrs.version;
    hash = "sha256-UqTgunWXBg4Qgk3qLDTZxfr95HeZ+D27cE0xuXoX1xg=";
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
    systemdLibs
  ];

  cmakeFlags = [
    (lib.cmakeBool "linyaps-box_ENABLE_SECCOMP" true)
    (lib.cmakeBool "linyaps-box_OFFLINE_BUILD" true)
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
