{
  lib,
  testers,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtk3,
  ncurses,
  libcpuid,
  pciutils,
  procps,
  wrapGAppsHook3,
  nasm,
  opencl-headers,
  ocl-icd,
  vulkan-headers,
  vulkan-loader,
  glfw,
  libxdmcp,
  pcre,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  dbus,
  at-spi2-core,
  libxtst,
  gtkmm3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpu-x";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "TheTumultuousUnicornOfDarkness";
    repo = "CPU-X";
    tag = "v${finalAttrs.version}";
    hash = "sha256-db7NxoVZgnYb1MZKfiFINx00JqDnf/TvwumBp6qDooQ=";
  };

  postPatch = ''
    # https://github.com/TheTumultuousUnicornOfDarkness/CPU-X/pull/402
    # FIXME: remove in the next version
    substituteInPlace src/core/bandwidth/{OOC/utility,routines}-x86-64bit.asm \
      --replace-fail "cpu	ia64" "cpu	default"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    nasm
  ];

  buildInputs = [
    gtk3
    gtkmm3
    ncurses
    libcpuid
    pciutils
    procps
    vulkan-headers
    vulkan-loader
    glfw
    opencl-headers
    ocl-icd
    libxdmcp
    pcre
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxkbcommon
    libepoxy
    dbus
    at-spi2-core
    libxtst
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
      --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    )
  '';

  passthru = {
    tests = {
      version = testers.testVersion { package = finalAttrs.finalPackage; };
    };
  };

  meta = {
    description = "Free software that gathers information on CPU, motherboard and more";
    mainProgram = "cpu-x";
    homepage = "https://thetumultuousunicornofdarkness.github.io/CPU-X";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ viraptor ];
  };
})
