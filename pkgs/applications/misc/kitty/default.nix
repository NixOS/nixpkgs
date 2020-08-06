{ stdenv, substituteAll, fetchFromGitHub, python3Packages, libunistring,
  harfbuzz, fontconfig, pkgconfig, ncurses, imagemagick, xsel,
  libstartup_notification, libGL, libX11, libXrandr, libXinerama, libXcursor,
  libxkbcommon, libXi, libXext, wayland-protocols, wayland,
  installShellFiles,
  dbus,
  Cocoa,
  CoreGraphics,
  Foundation,
  IOKit,
  Kernel,
  OpenGL,
  libcanberra,
  libicns,
  libpng,
  python3,
  zlib,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "kitty";
  version = "0.18.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "0x6h8g017mbpjkpkb1y8asyfdc48bgjzmj5gachsp5cf5jcqwir2";
  };

  buildInputs = [
    harfbuzz
    ncurses
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    Cocoa
    CoreGraphics
    Foundation
    IOKit
    Kernel
    OpenGL
    libpng
    python3
    zlib
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    fontconfig libunistring libcanberra libX11
    libXrandr libXinerama libXcursor libxkbcommon libXi libXext
    wayland-protocols wayland dbus
  ];

  nativeBuildInputs = [
    pkgconfig sphinx ncurses
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    imagemagick
    libicns  # For the png2icns tool.
    installShellFiles
  ];

  propagatedBuildInputs = stdenv.lib.optional stdenv.isLinux libGL;

  outputs = [ "out" "terminfo" ];

  patches = [
    ./fix-paths.patch
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    ./no-lto.patch
  ];

  # Causes build failure due to warning
  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "strictoverflow";

  dontConfigure = true;

  buildPhase = if stdenv.isDarwin then ''
    ${python.interpreter} setup.py kitty.app --update-check-interval=0
    make man
  '' else ''
    ${python.interpreter} setup.py linux-package \
    --update-check-interval=0 \
    --egl-library='${stdenv.lib.getLib libGL}/lib/libEGL.so.1' \
    --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
    --canberra-library='${libcanberra}/lib/libcanberra.so'
  '';

  checkInputs = [ pillow ];

  checkPhase =
    let buildBinPath =
      if stdenv.isDarwin
        then "kitty.app/Contents/MacOS"
        else "linux-package/bin";
    in
    ''
      env PATH="${buildBinPath}:$PATH" ${python.interpreter} test.py
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    ${if stdenv.isDarwin then ''
    mkdir "$out/bin"
    ln -s ../Applications/kitty.app/Contents/MacOS/kitty "$out/bin/kitty"
    mkdir "$out/Applications"
    cp -r kitty.app "$out/Applications/kitty.app"

    installManPage 'docs/_build/man/kitty.1'
    '' else ''
    cp -r linux-package/{bin,share,lib} $out
    ''}
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${stdenv.lib.makeBinPath [ imagemagick xsel ncurses.dev ]}"
    runHook postInstall

    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    "$out/bin/kitty" + complete setup fish > "$out/share/fish/vendor_completions.d/kitty.fish"
    "$out/bin/kitty" + complete setup bash > "$out/share/bash-completion/completions/kitty.bash"
    "$out/bin/kitty" + complete setup zsh > "$out/share/zsh/site-functions/_kitty"
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
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3;
    changelog = "https://sw.kovidgoyal.net/kitty/changelog.html";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ tex rvolosatovs Luflosi ];
  };
}
