{ lib, stdenv, fetchFromGitHub, python3Packages, libunistring,
  harfbuzz, fontconfig, pkg-config, ncurses, imagemagick, xsel,
  libstartup_notification, libGL, libX11, libXrandr, libXinerama, libXcursor,
  libxkbcommon, libXi, libXext, wayland-protocols, wayland,
  lcms2,
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
  version = "0.21.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "0y0mg8rr18mn0wzym7v48x6kl0ixd5q387kr5jhbdln55ph2jk9d";
  };

  buildInputs = [
    harfbuzz
    ncurses
    lcms2
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
    CoreGraphics
    Foundation
    IOKit
    Kernel
    OpenGL
    libpng
    python3
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    fontconfig libunistring libcanberra libX11
    libXrandr libXinerama libXcursor libxkbcommon libXi libXext
    wayland-protocols wayland dbus
  ];

  nativeBuildInputs = [
    pkg-config sphinx ncurses
    installShellFiles
  ] ++ lib.optionals stdenv.isDarwin [
    imagemagick
    libicns  # For the png2icns tool.
  ];

  propagatedBuildInputs = lib.optional stdenv.isLinux libGL;

  outputs = [ "out" "terminfo" ];

  # Causes build failure due to warning
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  preBuild = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11" && stdenv.isDarwin) ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    ${if stdenv.isDarwin then ''
      ${python.interpreter} setup.py kitty.app \
      --update-check-interval=0 \
      --disable-link-time-optimization
      make man
    '' else ''
      ${python.interpreter} setup.py linux-package \
      --update-check-interval=0 \
      --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
      --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
      --canberra-library='${libcanberra}/lib/libcanberra.so'
    ''}
    runHook postBuild
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
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${lib.makeBinPath [ imagemagick xsel ncurses.dev ]}"
    runHook postInstall

    installShellCompletion --cmd kitty \
      --bash <("$out/bin/kitty" + complete setup bash) \
      --fish <("$out/bin/kitty" + complete setup fish) \
      --zsh  <("$out/bin/kitty" + complete setup zsh)
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

  meta = with lib; {
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3Only;
    changelog = "https://sw.kovidgoyal.net/kitty/changelog.html";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ tex rvolosatovs Luflosi ];
  };
}
