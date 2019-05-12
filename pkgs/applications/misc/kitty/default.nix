{ stdenv, substituteAll, fetchFromGitHub, python3Packages, glfw, libunistring,
  harfbuzz, fontconfig, pkgconfig, ncurses, imagemagick, xsel,
  libstartup_notification, libX11, libXrandr, libXinerama, libXcursor,
  libxkbcommon, libXi, libXext, wayland-protocols, wayland,
  which, dbus, fetchpatch,
  Cocoa,
  CoreGraphics,
  Foundation,
  IOKit,
  Kernel,
  OpenGL,
  cf-private,
  libicns,
  libpng,
  librsvg,
  optipng,
  python3,
  zlib,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "kitty";
  version = "0.13.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "1y0vd75j8g61jdj8miml79w5ri3pqli5rv9iq6zdrxvzfa4b2rmb";
  };

  buildInputs = [
    ncurses harfbuzz
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    Cocoa
    CoreGraphics
    Foundation
    IOKit
    Kernel
    OpenGL
    cf-private
    libpng
    python3
    zlib
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    fontconfig glfw libunistring libX11
    libXrandr libXinerama libXcursor libxkbcommon libXi libXext
    wayland-protocols wayland dbus
  ];

  nativeBuildInputs = [
    pkgconfig which sphinx ncurses
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    imagemagick
    libicns  # For the png2icns tool.
    librsvg
    optipng
  ];

  outputs = [ "out" "terminfo" ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libstartup_notification = "${libstartup_notification}/lib/libstartup-notification-1.so";
    })
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      name = "macos-symlink-1";
      url = https://github.com/kovidgoyal/kitty/commit/bdeec612667f6976109247fe1750b10dda9c24c0.patch;
      sha256 = "1d18x260w059qag80kgb2cgi2h4rricvqhwpbrw79s8yxzs7jhxk";
    })
    (fetchpatch {
      # fixup of previous patch
      name = "macos-symlink-2";
      url = https://github.com/kovidgoyal/kitty/commit/af2c9a49b1ad31e94242295d88598591623fbf11.patch;
      sha256 = "0k3dmgbvmh66j8k3h8dw6la6ma6f20fng6jjypy982kxvracsnl5";
    })
    ./macos-10.11.patch
    ./no-lto.patch
    ./no-werror.patch
    ./png2icns.patch
  ];

  buildPhase = if stdenv.isDarwin then ''
    make app
  '' else ''
    ${python.interpreter} setup.py linux-package
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    ${if stdenv.isDarwin then ''
    mkdir "$out/bin"
    ln -s ../Applications/kitty.app/Contents/MacOS/kitty-deref-symlink "$out/bin/kitty"
    mkdir "$out/Applications"
    cp -r kitty.app "$out/Applications/kitty.app"
    '' else ''
    cp -r linux-package/{bin,share,lib} $out
    ''}
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${stdenv.lib.makeBinPath [ imagemagick xsel ]}"
    runHook postInstall

    # ZSH completions need to be invoked with `source`:
    # https://github.com/kovidgoyal/kitty/blob/8ceb941051b89b7c50850778634f0b6137aa5e6e/docs/index.rst#zsh
    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    "$out/bin/kitty" + complete setup fish > "$out/share/fish/vendor_completions.d/kitty.fish"
    "$out/bin/kitty" + complete setup bash > "$out/share/bash-completion/completions/kitty.bash"
  '';

  postInstall = ''
    terminfo_src=${if stdenv.isDarwin then
      ''"$out/Applications/kitty.app/Contents/Resources/terminfo"''
      else
      "$out/share/terminfo"}

    mkdir -p $terminfo/share
    mv "$terminfo_src" $terminfo/share/terminfo

    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/kovidgoyal/kitty;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ tex rvolosatovs ];
  };
}
