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

stdenv.mkDerivation rec {
  pname = "servo";
  version = "unstable-2023-03-11";

  src = fetchFromGitHub {
    owner = "servo";
    repo = pname;
    rev = "cd81a7ae85101ffd41ec838d667ae9ed1c367bd2";
    hash = "sha256-GKrAmfs1wCjMaHrxM4BAr773HcoIy0bEAUS7UbsQ6FM=";
    fetchSubmodules = true;
  };

  buildInputs = [
    # Native dependencies
    fontconfig freetype openssl libunwind
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
