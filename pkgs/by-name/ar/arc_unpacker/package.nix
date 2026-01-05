{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  makeWrapper,
  ninja,
  boost,
  libpng,
  libiconv,
  libjpeg,
  zlib,
  openssl,
  libwebp,
  catch2,
}:

stdenv.mkDerivation {
  pname = "arc_unpacker";
  version = "unstable-2021-08-06";

  src = fetchFromGitHub {
    owner = "vn-tools";
    repo = "arc_unpacker";
    rev = "456834ecf2e5686813802c37efd829310485c57d";
    hash = "sha256-STbdWH7Mr3gpOrZvujblYrIIKEWBHzy1/BaNuh4teI8=";
  };

  patches = [ ./fix-test-float-variance.patch ];

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp tests/test_support/catch.h

    # missing includes
    sed '1i#include <limits>' -i src/dec/eagls/pak_archive_decoder.cc # gcc12
    sed '1i#include <cstdint>' -i src/types.h # gcc13
    sed '1i#include <vector>' -i src/flow/cli_facade.h # gcc14

    # cmake-4 support
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.8.8)' \
      'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    catch2
  ];

  buildInputs = [
    boost
    libiconv
    libjpeg
    libpng
    libwebp
    openssl
    zlib
  ];

  checkPhase =
    let
      checkTarget = [
        "~CatSystem INT archives"
      ]
      ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [ "~Ivory WADY audio" ];
    in
    ''
      # Specify test targets
      # https://catch2-temp.readthedocs.io/en/latest/command-line.html#specifying-which-tests-to-run
      checkTarget=(${lib.escapeShellArgs checkTarget})

      runHook preCheck

      local flagsArray=()
      concatTo flagsArray checkFlags checkFlagsArray checkTarget

      pushd ..
      echoCmd 'check flags' "''${flagsArray[@]}"
      ./build/run_tests "''${flagsArray[@]}"
      popd

      runHook postCheck
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/doc/arc_unpacker $out/libexec/arc_unpacker
    cp arc_unpacker $out/libexec/arc_unpacker/arc_unpacker
    cp ../GAMELIST.{htm,js} $out/share/doc/arc_unpacker
    cp -r ../etc $out/libexec/arc_unpacker
    makeWrapper $out/libexec/arc_unpacker/arc_unpacker $out/bin/arc_unpacker

    runHook postInstall
  '';

  doCheck = true;

  meta = with lib; {
    description = "Tool to extract files from visual novel archives";
    homepage = "https://github.com/vn-tools/arc_unpacker";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.all;
    mainProgram = "arc_unpacker";
  };
}
