{
  callPackage,
  cmake,
  fetchFromGitHub,
  glib,
  lib,
  libx11,
  pkg-config,
  stdenv,
}:
let
  libdbusmenu-jb = callPackage ./libdbusmenu.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jetbrains-libdbm";
  # nixpkgs-update: no auto update
  # In practice this package does not need to be regularly updated,
  # at the time of writing the last change was 4 years ago.
  # Check before updating.
  version = "2025.3.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "intellij-community";
    tag = "idea/${finalAttrs.version}";
    hash = "sha256-5rPaXIGOeWY9tcHRs5p376kgo4EbUtEltwcmNpPSsM8=";
  };
  sourceRoot = "source/native/LinuxGlobalMenu";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    libx11
    libdbusmenu-jb
  ];

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
