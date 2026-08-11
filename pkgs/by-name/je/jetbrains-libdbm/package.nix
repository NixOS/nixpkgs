{
  cmake,
  fetchFromGitHub,
  glib,
  jetbrains,
  lib,
  libdbusmenu,
  libx11,
  pkg-config,
  stdenv,
}:
let
  libdbusmenu-jb = libdbusmenu.overrideAttrs (old: {
    version = "jetbrains-fork";
    src = fetchFromGitHub {
      owner = "jetbrains";
      repo = "libdbusmenu";
      rev = "d8a49303f908a272e6670b7cee65a2ba7c447875";
      hash = "sha256-u87ZgbfeCPJ0qG8gsom3gFaZxbS5NcHEodb0EVakk60=";
    };
    configureFlags = old.configureFlags ++ [
      "--enable-static"
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp libdbusmenu-glib/.libs/libdbusmenu-glib.a $out/lib

      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jetbrains-libdbm";
  # Note: In practice this package does not need to be regularly updated,
  # at the time of writing the last change was 4 years ago. Check before updating.
  version = "2025.3.4";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    libx11
    libdbusmenu # TODO: Why is this a buildInput and not libdbusmenu-jb instead...?
  ];

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "intellij-community";
    rev = "idea/${finalAttrs.version}";
    hash = "sha256-5rPaXIGOeWY9tcHRs5p376kgo4EbUtEltwcmNpPSsM8=";
  };
  sourceRoot = "source/native/LinuxGlobalMenu";

  patches = [ ./headers.patch ];
  postPatch = ''
    # Fix the build with CMake 4.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.6.0)' 'cmake_minimum_required(VERSION 3.10)'
    cp ${libdbusmenu-jb}/lib/libdbusmenu-glib.a libdbusmenu-glib.a
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mv libdbm.so $out/lib/libdbm.so

    runHook postInstall
  '';

  meta = {
    description = "libdbusmenu wrapper by JetBrains for their IDEs";
    homepage = "https://github.com/JetBrains/intellij-community/tree/master/native/LinuxGlobalMenu";
    license = lib.licenses.asl20;
    teams = [ lib.teams.jetbrains ];
    platforms = lib.platforms.linux;
  };
})
