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
  version = "2018-07-20";

  # At the moment we cannot handle git dependencies in buildRustPackage.
  # This fork only replaces rust-fontconfig/libfontconfig with a git submodules.
  src = fetchgit {
    url = https://github.com/Mic92/alacritty.git;
    rev = "rev-${version}";
    sha256 = "1vhjmysfra6dsbv35qbvsf76rhkj990lgns0k0gpbcrf47gsvx1n";
    fetchSubmodules = true;
  };

  cargoSha256 = "0rs2p4sik25ynx6ri2wlg8v6vrdmf10xxnw9f2aqyps9m038i9di";

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

  postBuild = lib.optionalString stdenv.isDarwin "make app";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

  '' + (if stdenv.isDarwin then ''
    mkdir $out/Applications
    cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
  '' else ''
    install -D alacritty.desktop $out/share/applications/alacritty.desktop
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '') + ''

    install -D alacritty-completions.zsh "$out/share/zsh/site-functions/_alacritty"
    install -D alacritty-completions.bash "$out/etc/bash_completion.d/alacritty-completions.bash"
    install -D alacritty-completions.fish "$out/share/fish/vendor_completions.d/alacritty.fish"

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
