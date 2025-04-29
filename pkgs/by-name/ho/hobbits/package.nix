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
    substituteInPlace CMakeLists.txt \
      --replace-warn "SELF_CONTAINED_APP OR APPLE" "SELF_CONTAINED_APP"
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

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/hobbits.app $out/Applications
    wrapProgram $out/Applications/hobbits.app/Contents/MacOS/hobbits \
      --prefix DYLD_LIBRARY_PATH : $out/Applications/hobbits.app/Contents/Frameworks
    ln -s $out/Applications/hobbits.app/Contents/MacOS/hobbits $out/bin/hobbits
    # Prevent wrapping
    find $out/Applications -type f -name "*.dylib" -exec chmod -x {} \;
  '';

  meta = {
    description = "Multi-platform GUI for bit-based analysis, processing, and visualization";
    homepage = "https://github.com/Mahlet-Inc/hobbits";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
