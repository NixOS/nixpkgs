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
  wayland,
  libxkbcommon,
  # Darwin Frameworks
  cf-private,
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
  ] ++ lib.optionals stdenv.isLinux [
    wayland
    libxkbcommon
  ];
in buildRustPackage rec {
  name = "alacritty-${version}";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "v${version}";
    sha256 = "01wzkpbz6jjmpmnkqswilnn069ir3cx3jvd3j7zsvqdxqpwncz39";
  };

  cargoSha256 = "0h9wczgpjh52lhrqg0r2dkrh5svmyvrvh4yj7p0nz45skgrnl8w9";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
    ncurses
    gzip
  ];

  buildInputs = rpathLibs
    ++ lib.optionals stdenv.isDarwin [
      AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL
      # Needed for CFURLResourceIsReachable symbols.
      cf-private
    ];

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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
