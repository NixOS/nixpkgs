{ lib
, stdenv
, fetchFromGitHub
, fontconfig
, freetype
, openssl
, libunwind
, xorg
, gst_all_1
, rustup
, cmake
, dbus
, gcc
, git
, pkg-config
, which
, llvm
, autoconf213
, perl
, yasm
, m4
, python3
, darwin
}:

stdenv.mkDerivation {
  pname = "servo";
  version = "0-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "servo";
    repo = "servo";
    rev = "9f32809671c8c8e79d59c95194dcc466452299fc";
    hash = "";
    fetchSubmodules = true;
  };

  buildInputs = [
    # Native dependencies
    fontconfig
    freetype
    openssl
    libunwind
    xorg.libxcb

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad

    rustup

    # Build utilities
    cmake dbus gcc git pkg-config which llvm autoconf213 perl yasm m4
    (python3.withPackages (ps: with ps; [virtualenv pip dbus]))

  ] ++ (lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ]);

  enableParallelBuilding = true;

  configurePhase = ''
    runHook preConfigure


    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ./mach build --release

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./mach run --release tests/html/about-mozilla.html

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://servo.org";
    description = "Servo is a prototype web browser engine written in the Rust language.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = platforms.unix;
  };
}
