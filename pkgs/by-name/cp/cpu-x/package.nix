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
  libXdmcp,
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
  libXtst,
  gtkmm3,
}:

# Known issues:
# - The daemon can't be started from the GUI, because pkexec requires a shell
#   registered in /etc/shells. The nix's bash is not in there when running
#   cpu-x from nixpkgs.

stdenv.mkDerivation (finalAttrs: {
  pname = "cpu-x";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "X0rg";
    repo = "CPU-X";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-4wW8elGsU3EhDDMPxa5di01NlB0dJ8MN8TiaIBo2qxo=";
  };

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
    libXdmcp
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
    libXtst
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
