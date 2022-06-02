{ lib, stdenv, fetchFromGitHub, python3Packages, libunistring
, harfbuzz, fontconfig, pkg-config, ncurses, imagemagick
, libstartup_notification, libGL, libX11, libXrandr, libXinerama, libXcursor
, libxkbcommon, libXi, libXext, wayland-protocols, wayland
, lcms2
, librsync
, installShellFiles
, dbus
, darwin
, Cocoa
, CoreGraphics
, Foundation
, IOKit
, Kernel
, OpenGL
, libcanberra
, libicns
, libpng
, python3
, zlib
, bashInteractive
, zsh
, fish
, fetchpatch
, nixosTests
}:

with python3Packages;
buildPythonApplication rec {
  pname = "kitty";
  version = "0.25.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "v${version}";
    sha256 = "sha256-RYQVcbyKIv/FlrtROoQywWR+iF+4KYiYrrzErUrOCWM=";
  };

  buildInputs = [
    harfbuzz
    ncurses
    lcms2
    librsync
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
  ] ++ lib.optionals (stdenv.isDarwin && (builtins.hasAttr "UserNotifications" darwin.apple_sdk.frameworks)) [
    darwin.apple_sdk.frameworks.UserNotifications
  ] ++ lib.optionals stdenv.isLinux [
    fontconfig libunistring libcanberra libX11
    libXrandr libXinerama libXcursor libxkbcommon libXi libXext
    wayland-protocols wayland dbus libGL
  ];

  nativeBuildInputs = [
    installShellFiles
    ncurses
    pkg-config
    sphinx
    furo
    sphinx-copybutton
    sphinxext-opengraph
    sphinx-inline-tabs
  ] ++ lib.optionals stdenv.isDarwin [
    imagemagick
    libicns  # For the png2icns tool.
  ];

  outputs = [ "out" "terminfo" "shell_integration" ];

  patches = [
    # Required to get `test_ssh_env_vars` to pass.
    (fetchpatch {
      name = "increase-pty-lines.patch";
      url = "https://github.com/kovidgoyal/kitty/commit/eb84990f5a8edc458e04d24cc1cda05316d74ceb.patch";
      sha256 = "sha256-eOANfhGPMoN4FqxtIGDBu5X0O3RPLABDnL+LKqSLROI=";
    })
    # Fix to ensure that files in tar files used by SSH kitten have write permissions.
    ./tarball-restore-write-permissions.patch

    # Needed on darwin

    # Gets `test_ssh_shell_integration` to pass for `zsh` when `compinit` complains about
    # permissions.
    ./zsh-compinit.patch
    # Skip `test_ssh_login_shell_detection` in some cases, build users have their shell set to
    # `/sbin/nologin` which causes issues.
    ./disable-test_ssh_login_shell_detection.patch
    # Skip `test_ssh_bootstrap_with_different_launchers` when launcher is `zsh` since it causes:
    # OSError: master_fd is in error condition
    ./disable-test_ssh_bootstrap_with_different_launchers.patch
  ];

  # Causes build failure due to warning
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  dontConfigure = true;

  buildPhase = let
    commonOptions = ''
      --update-check-interval=0 \
      --shell-integration=enabled\ no-rc
    '';
  in ''
    runHook preBuild
    ${if stdenv.isDarwin then ''
      ${python.interpreter} setup.py kitty.app \
      --disable-link-time-optimization \
      ${commonOptions}
      make man
    '' else ''
      ${python.interpreter} setup.py linux-package \
      --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
      --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
      --canberra-library='${libcanberra}/lib/libcanberra.so' \
      ${commonOptions}
    ''}
    runHook postBuild
  '';

  checkInputs = [
    pillow

    # Shells needed for shell integration tests
    bashInteractive
    zsh
    fish
  ];

  checkPhase =
    let buildBinPath =
      if stdenv.isDarwin
        then "kitty.app/Contents/MacOS"
        else "linux-package/bin";
    in
    ''
      # Fontconfig error: Cannot load default config file: No such file: (null)
      export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf

      # Required for `test_ssh_shell_integration` to pass.
      export TERM=kitty

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
    wrapProgram "$out/bin/kitty" --prefix PATH : "$out/bin:${lib.makeBinPath [ imagemagick ncurses.dev ]}"

    installShellCompletion --cmd kitty \
      --bash <("$out/bin/kitty" +complete setup bash) \
      --fish <("$out/bin/kitty" +complete setup fish2) \
      --zsh  <("$out/bin/kitty" +complete setup zsh)

    terminfo_src=${if stdenv.isDarwin then
      ''"$out/Applications/kitty.app/Contents/Resources/terminfo"''
      else
      "$out/share/terminfo"}

    mkdir -p $terminfo/share
    mv "$terminfo_src" $terminfo/share/terminfo

    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    cp -r 'shell-integration' "$shell_integration"

    runHook postInstall
  '';

  # Patch shebangs that Nix can't automatically patch
  preFixup =
    let
      pathComponent = if stdenv.isDarwin then "Applications/kitty.app/Contents/Resources" else "lib";
    in
    ''
      substituteInPlace $out/${pathComponent}/kitty/shell-integration/ssh/askpass.py \
        --replace '/usr/bin/env -S ' $out/bin/
      substituteInPlace $shell_integration/ssh/askpass.py \
        --replace '/usr/bin/env -S ' $out/bin/
    '';

  passthru.tests.test = nixosTests.terminal-emulators.kitty;

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3Only;
    changelog = "https://sw.kovidgoyal.net/kitty/changelog/";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ tex rvolosatovs Luflosi ];
  };
}
