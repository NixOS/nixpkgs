{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gtk3, ncurses
, libcpuid, pciutils, procps, wrapGAppsHook, nasm, makeWrapper
, opencl-headers, ocl-icd
, vulkan-headers, vulkan-loader, glfw
, libXdmcp, pcre, util-linux
, libselinux, libsepol
, libthai, libdatrie, libxkbcommon, libepoxy
, dbus, at-spi2-core
, libXtst
}:

# Known issues:
# - The daemon can't be started from the GUI, because pkexec requires a shell
#   registered in /etc/shells. The nix's bash is not in there when running
#   cpu-x from nixpkgs.

stdenv.mkDerivation rec {
  pname = "cpu-x";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "X0rg";
    repo = "CPU-X";
    rev = "v${version}";
    sha256 = "sha256-tdxIbs5jR4sQHt1ZLUmiAYszP2e5SCMqEFq+eW1k7+s=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook nasm makeWrapper ];
  buildInputs = [
    gtk3 ncurses libcpuid pciutils procps
    vulkan-headers vulkan-loader glfw
    opencl-headers ocl-icd
    libXdmcp pcre util-linux
    libselinux libsepol
    libthai libdatrie libxkbcommon libepoxy
    dbus at-spi2-core
    libXtst
  ];

  postInstall = ''
    wrapProgram $out/bin/cpu-x \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]} \
      --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
  '';

  meta = with lib; {
    description = "Free software that gathers information on CPU, motherboard and more";
    homepage = "https://thetumultuousunicornofdarkness.github.io/CPU-X";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ viraptor ];
  };
}
