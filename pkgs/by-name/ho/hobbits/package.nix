{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pffft,
  libpcap,
  libusb1,
  python3,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hobbits";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "Mahlet-Inc";
    repo = "hobbits";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W6QBLj+GkmM88cOVSIc1PLiVXysjv74J7citFW6SRDM=";
  };

  postPatch = ''
    substituteInPlace src/hobbits-core/settingsdata.cpp \
      --replace-warn "pythonHome = \"/usr\"" "pythonHome = \"${python3}\""
    substituteInPlace cmake/gitversion.cmake \
      --replace-warn "[Mystery Build]" "${finalAttrs.version}"
  '';

  buildInputs = [
    pffft
    libpcap
    libusb1
    python3
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  cmakeFlags = [ (lib.cmakeBool "USE_SYSTEM_PFFFT" true) ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isAarch64 "-Wno-error=narrowing";

  meta = {
    description = "Multi-platform GUI for bit-based analysis, processing, and visualization";
    homepage = "https://github.com/Mahlet-Inc/hobbits";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
  };
})
