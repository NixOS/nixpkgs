{ lib
, stdenv
, fetchurl
, cmake
, qttools
, qtbase
, qtdeclarative
, qtsvg
, qtwayland
, qtwebsockets
, makeWrapper
, wrapQtAppsHook
, botan2
, pkg-config
, nixosTests
, installShellFiles
, xvfb-run
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "24.12.4";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz";
    hash = "sha256-1DHBi++7GlSxnA8fAWC4rHej9wi8jDvI2pQduqZhNZQ=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
    pkg-config
    installShellFiles
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xvfb-run ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebsockets
    botan2
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ qtwayland ];

  cmakeFlags = [
    "-DQON_QT6_BUILD=ON"
    "-DBUILD_WITH_SYSTEM_BOTAN=ON"
  ];

  # Install shell completion on Linux (with xvfb-run)
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
      installShellCompletion --cmd ${appname} \
        --bash <(xvfb-run $out/bin/${appname} --completion bash) \
        --fish <(xvfb-run $out/bin/${appname} --completion fish)
      installShellCompletion --cmd ${pname} \
        --bash <(xvfb-run $out/bin/${appname} --completion bash) \
        --fish <(xvfb-run $out/bin/${appname} --completion fish)
  ''
  # Install shell completion on macOS
  + lib.optionalString stdenv.isDarwin ''
      installShellCompletion --cmd ${pname} \
        --bash <($out/bin/${appname} --completion bash) \
        --fish <($out/bin/${appname} --completion fish)
  ''
  # Create a lowercase symlink for Linux
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    ln -s $out/bin/${appname} $out/bin/${pname}
  ''
  # Rename application for macOS as lowercase binary
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Prevent "same file" error
    mv $out/bin/${appname} $out/bin/${pname}.bin
    mv $out/bin/${pname}.bin $out/bin/${pname}
  '';

  # Tests QOwnNotes using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.qownnotes;

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    changelog = "https://www.qownnotes.org/changelog.html";
    downloadPage = "https://github.com/pbek/QOwnNotes/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbek totoroot ];
    platforms = platforms.unix;
  };
}
