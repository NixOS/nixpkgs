{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  curl,
  libGL,
  libX11,
  libXxf86dga,
  alsa-lib,
  libXrandr,
  libXxf86vm,
  libXext,
  SDL2,
  glibc,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  arch = if stdenv.hostPlatform.isx86_64 then "x64" else stdenv.hostPlatform.parsed.cpu.name;
in
stdenv.mkDerivation rec {
  pname = "Quake3e";
  version = "2024-09-02-dev";

  src = fetchFromGitHub {
    owner = "ec-";
    repo = pname;
    rev = "b6e7ce4f78711e1c9d2924044a9a9d8a9db7020f";
    sha256 = "sha256-tQgrHiP+QhBzcUnHRwzaDe38Th0uDt450fra8O3Vjqc=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];
  buildInputs = [
    curl
    libGL
    libX11
    libXxf86dga
    alsa-lib
    libXrandr
    libXxf86vm
    libXext
    SDL2
    glibc
  ];
  env.NIX_CFLAGS_COMPILE = "-I${SDL2.dev}/include/SDL2";
  enableParallelBuilding = true;

  postPatch = ''
    sed -i -e 's#OpenGLLib = dlopen( dllname#OpenGLLib = dlopen( "${libGL}/lib/libGL.so"#' code/unix/linux_qgl.c
    sed -i -e 's#Sys_LoadLibrary( "libpthread.so.0" )#Sys_LoadLibrary( "${glibc}/lib/libpthread.so.0" )#' code/unix/linux_snd.c
    sed -i -e 's#Sys_LoadLibrary( "libasound.so.2" )#Sys_LoadLibrary( "${alsa-lib}/lib/libasound.so.2" )#' code/unix/linux_snd.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86dga.so.1" )#Sys_LoadLibrary( "${libXxf86dga}/lib/libXxf86dga.so.1" )#' code/unix/x11_dga.c
    sed -i -e 's#Sys_LoadLibrary( "libXrandr.so.2" )#Sys_LoadLibrary( "${libXrandr}/lib/libXrandr.so.2" )#' code/unix/x11_randr.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86vm.so.1" )#Sys_LoadLibrary( "${libXxf86vm}/lib/libXxf86vm.so.1" )#' code/unix/x11_randr.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86vm.so.1" )#Sys_LoadLibrary( "${libXxf86vm}/lib/libXxf86vm.so.1" )#' code/unix/x11_vidmode.c
    sed -i -e 's#"libcurl.so.4"#"${curl.out}/lib/libcurl.so.4"#' code/client/cl_curl.h
  '';

  # Default value for `USE_SDL` changed (from 0 to 1) in 5f8ce6d (2020-12-26)
  # Setting `USE_SDL=0` in `makeFlags` doesn't work
  preConfigure = ''
    sed -i 's/USE_SDL *= 1/USE_SDL = 0/' Makefile
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR=$out/lib
    makeWrapper $out/lib/quake3e.${arch} $out/bin/quake3e
    makeWrapper $out/lib/quake3e.ded.${arch} $out/bin/quake3e.ded
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Quake3e";
      exec = "quake3e";
      desktopName = "Quake3e";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/ec-/Quake3e";
    description = "Improved Quake III Arena engine";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      pmiddend
      alx
    ];
  };
}
