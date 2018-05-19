{ stdenv,
  lib,
  fetchgit,
  rustPlatform,
  cmake,
  makeWrapper,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gperf,
  libXcursor,
  libXxf86vm,
  libXi,
  libXrandr,
  libGL,
  xclip,
  # Darwin Frameworks
  AppKit,
  CoreFoundation,
  CoreGraphics,
  CoreServices,
  CoreText,
  Foundation,
  OpenGL }:

with rustPlatform;

let
  rpathLibs = [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXrandr
    libGL
    libXi
  ];
  darwinFrameworks = [
    AppKit
    CoreFoundation
    CoreGraphics
    CoreServices
    CoreText
    Foundation
    OpenGL
  ];
in buildRustPackage rec {
  name = "alacritty-unstable-${version}";
  version = "2018-04-16";

  # At the moment we cannot handle git dependencies in buildRustPackage.
  # This fork only replaces rust-fontconfig/libfontconfig with a git submodules.
  src = fetchgit {
    url = https://github.com/Mic92/alacritty.git;
    rev = "rev-${version}";
    sha256 = "14qsfaij631pk0gxrhmp594f72v0z7kzymf4hnqv4k5w9xlxciwx";
    fetchSubmodules = true;
  };

  cargoSha256 = "0gg28fbx0kisv7hqxgzqhv4z4ikk074djfjlj90nmmi4nddp017p";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
  ];

  buildInputs = rpathLibs
             ++ lib.optionals stdenv.isDarwin darwinFrameworks;

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  postBuild = if stdenv.isDarwin
    then ''
      make app
    ''
    else "";

  patchRPathLibs = if stdenv.isDarwin then "" else ''
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '';

  copyDarwinApp = if stdenv.isDarwin
    then ''
      mkdir $out/Applications
      cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
    ''
    else "";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty
    ${patchRPathLibs}

    install -D Alacritty.desktop $out/share/applications/alacritty.desktop

    ${copyDarwinApp}

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
  };
}
