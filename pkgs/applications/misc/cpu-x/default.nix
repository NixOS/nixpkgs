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

stdenv.mkDerivation rec {
  pname = "cpu-x";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "X0rg";
    repo = "CPU-X";
    rev = "v${version}";
    sha256 = "sha256-PNfEiin4Hble/H8cOvSK+A7wmoeOlyITRUTwGTd3B6s=";
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
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ viraptor ];
  };
}
