{ stdenv
, lib
, fetchFromGitHub
, rustPlatform

, cmake
, gzip
, installShellFiles
, makeWrapper
, ncurses
, pkgconfig
, python3

, expat
, fontconfig
, freetype
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, libXxf86vm
, libxcb
, libxkbcommon
, wayland
, xdg_utils

  # Darwin Frameworks
, AppKit
, CoreGraphics
, CoreServices
, CoreText
, Foundation
, OpenGL
}:
let
  rpathLibs = [
    expat
    fontconfig
    freetype
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libXxf86vm
    libxcb
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "alacritty";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "alacritty";
    repo = pname;
    rev = "v${version}";
    sha256 = "133d8vm7ihlvgw8n1jghhh35h664h0f52h6gci54f11vl6c1spws";
  };

  cargoSha256 = "07gq63qd11zz229b8jp9wqggz39qfpzd223z1zk1xch7rhqq0pn4";

  nativeBuildInputs = [
    cmake
    gzip
    installShellFiles
    makeWrapper
    ncurses
    pkgconfig
    python3
  ];

  buildInputs = rpathLibs
  ++ lib.optionals stdenv.isDarwin [
    AppKit
    CoreGraphics
    CoreServices
    CoreText
    Foundation
    OpenGL
  ];

  outputs = [ "out" "terminfo" ];

  postPatch = ''
    substituteInPlace alacritty/src/config/mouse.rs \
      --replace xdg-open ${xdg_utils}/bin/xdg-open
  '';

  postBuild = lib.optionalString stdenv.isDarwin "make app";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

  '' + (
    if stdenv.isDarwin then ''
      mkdir $out/Applications
      cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
    '' else ''
      install -D extra/linux/Alacritty.desktop -t $out/share/applications/
      install -D extra/logo/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg

      # patchelf generates an ELF that binutils' "strip" doesn't like:
      #    strip: not enough room for program headers, try linking with -N
      # As a workaround, strip manually before running patchelf.
      strip -S $out/bin/alacritty

      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
    ''
  ) + ''

    installShellCompletion --zsh extra/completions/_alacritty
    installShellCompletion --bash extra/completions/alacritty.bash
    installShellCompletion --fish extra/completions/alacritty.fish

    install -dm 755 "$out/share/man/man1"
    gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "A cross-platform, GPU-accelerated terminal emulator";
    homepage = "https://github.com/alacritty/alacritty";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 mic92 cole-h ];
    platforms = platforms.unix;
  };
}
