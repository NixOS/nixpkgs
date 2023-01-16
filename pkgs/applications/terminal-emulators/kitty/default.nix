{ lib, stdenv, fetchFromGitHub, fetchpatch, python3Packages, libunistring
, harfbuzz, fontconfig, pkg-config, ncurses, imagemagick
, libstartup_notification, libGL, libX11, libXrandr, libXinerama, libXcursor
, libxkbcommon, libXi, libXext, wayland-protocols, wayland
, lcms2
, librsync
, openssl
, installShellFiles
, dbus
, Libsystem
, Cocoa
, Kernel
, UniformTypeIdentifiers
, UserNotifications
, libcanberra
, libicns
, libpng
, python3
, zlib
, bashInteractive
, zsh
, fish
, nixosTests
}:

with python3Packages;
buildPythonApplication rec {
  pname = "kitty";
  version = "0.26.5";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-UloBlV26HnkvbzP/NynlPI77z09MBEVgtrg5SeTmwB4=";
  };

  buildInputs = [
    harfbuzz
    ncurses
    lcms2
    librsync
    openssl.dev
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
    Kernel
    UniformTypeIdentifiers
    UserNotifications
    libpng
    python3
    zlib
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    Libsystem
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
    # Fix clone-in-kitty not working on bash >= 5.2
    # TODO: Removed on kitty release > 0.26.5
    (fetchpatch {
      url = "https://github.com/kovidgoyal/kitty/commit/51bba9110e9920afbefeb981e43d0c1728051b5e.patch";
      sha256 = "sha256-1aSU4aU6j1/om0LsceGfhH1Hdzp+pPaNeWAi7U6VcP4=";
    })

    # Gets `test_ssh_env_vars` to pass when `bzip2` is in the output of `env`.
    ./fix-test_ssh_env_vars.patch

    # Needed on darwin

    # Gets `test_ssh_shell_integration` to pass for `zsh` when `compinit` complains about
    # permissions.
    ./zsh-compinit.patch

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
    darwinOptions = ''
      --disable-link-time-optimization \
      ${commonOptions}
    '';
  in ''
    runHook preBuild
    ${ lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) "export MACOSX_DEPLOYMENT_TARGET=11" }
    ${if stdenv.isDarwin then ''
      ${python.interpreter} setup.py build ${darwinOptions}
      make docs
      ${python.interpreter} setup.py kitty.app ${darwinOptions}
    '' else ''
      ${python.interpreter} setup.py build-launcher
      ${python.interpreter} setup.py linux-package \
      --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
      --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
      --canberra-library='${libcanberra}/lib/libcanberra.so' \
      --fontconfig-library='${fontconfig.lib}/lib/libfontconfig.so' \
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

  # skip failing tests due to darwin sandbox
  preCheck = lib.optionalString stdenv.isDarwin ''
    substituteInPlace kitty_tests/file_transmission.py \
      --replace test_file_get dont_test_file_get \
      --replace test_path_mapping_receive dont_test_path_mapping_receive
    substituteInPlace kitty_tests/shell_integration.py \
      --replace test_fish_integration dont_test_fish_integration
    substituteInPlace kitty_tests/open_actions.py \
      --replace test_parsing_of_open_actions dont_test_parsing_of_open_actions
    substituteInPlace kitty_tests/ssh.py \
      --replace test_ssh_connection_data dont_test_ssh_connection_data
    substituteInPlace kitty_tests/fonts.py \
      --replace 'class Rendering(BaseTest)' 'class Rendering'
  '';

  checkPhase = ''
      runHook preCheck

      # Fontconfig error: Cannot load default config file: No such file: (null)
      export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf

      # Required for `test_ssh_shell_integration` to pass.
      export TERM=kitty

      make test
      runHook postCheck
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
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3Only;
    changelog = "https://sw.kovidgoyal.net/kitty/changelog/";
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [ tex rvolosatovs Luflosi adamcstephens ];
  };
}
