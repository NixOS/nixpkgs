{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeWrapper,
  ncurses,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gzip,
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
  version = "2018-08-05";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "1adb5cb7fc05054197aa08e0d1fa957df94888ab";
    sha256 = "06rc7dy1vn59lc5hjh953h9lh0f39c0n0jmrz472mrya722fl2ab";
  };

  cargoSha256 = "0ms0248bb2lgbzcqks6i0qhn1gaiim3jf1kl17qw52c8an3rc652";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
    ncurses
    gzip
  ];

  buildInputs = rpathLibs
             ++ lib.optionals stdenv.isDarwin darwinFrameworks;

 outputs = [ "out" "terminfo" ];

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

    install -dm 755 "$out/share/man/man1"
    gzip -c alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -x -o "$terminfo/share/terminfo" alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

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
