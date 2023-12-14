{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, cmake
, pkg-config
, freetype
, fontconfig
, libunicode
, libutempter
, termbench-pro
, qtmultimedia
, wrapQtAppsHook
, pcre
, boost
, catch2
, fmt
, microsoft-gsl
, range-v3
, yaml-cpp
, ncurses
, file
, utmp
, sigtool
, nixosTests
, installShellFiles
}:

stdenv.mkDerivation (final: {
  pname = "contour";
  version = "0.3.12.262";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "contour";
    rev = "v${final.version}";
    hash = "sha256-4R0NyUtsyr3plYfVPom+EjJ5W0Cb/uuaSB5zyJ0yIB4=";
  };

  outputs = [ "out" "terminfo" ];

  # fix missing <QtMultimedia/QAudioSink> on Darwin and codesign the binary
  patches = [ ./contour-cmakelists.diff ./macos-codesign.diff ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ncurses
    file
    wrapQtAppsHook
    installShellFiles
  ] ++ lib.optionals stdenv.isDarwin [ sigtool ];

  buildInputs = [
    fontconfig
    freetype
    libunicode
    termbench-pro
    qtmultimedia
    pcre
    boost
    catch2
    fmt
    microsoft-gsl
    range-v3
    yaml-cpp
  ]
  ++ lib.optionals stdenv.isLinux [ libutempter ]
  ++ lib.optionals stdenv.isDarwin [ utmp ];

  cmakeFlags = [ "-DCONTOUR_QT_VERSION=6" ];

  preConfigure = ''
    # Don't fix Darwin app bundle
    sed -i '/fixup_bundle/d' src/contour/CMakeLists.txt
  '';

  postInstall = ''
    mkdir -p $out/nix-support $terminfo/share
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications
    installShellCompletion --zsh $out/contour.app/Contents/Resources/shell-integration/shell-integration.zsh
    installShellCompletion --fish $out/contour.app/Contents/Resources/shell-integration/shell-integration.fish
    cp -r $out/contour.app/Contents/Resources/terminfo $terminfo/share
    mv $out/contour.app $out/Applications
    ln -s $out/bin $out/Applications/contour.app/Contents/MacOS
  '' + lib.optionalString stdenv.isLinux ''
    mv $out/share/terminfo $terminfo/share/
    installShellCompletion --zsh $out/share/contour/shell-integration/shell-integration.zsh
    installShellCompletion --fish $out/share/contour/shell-integration/shell-integration.fish
  '' + ''
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  passthru.tests.test = nixosTests.terminal-emulators.contour;

  meta = with lib; {
    description = "Modern C++ Terminal Emulator";
    homepage = "https://github.com/contour-terminal/contour";
    changelog = "https://github.com/contour-terminal/contour/raw/v${version}/Changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ moni ];
    platforms = platforms.unix;
    mainProgram = "contour";
  };
})
