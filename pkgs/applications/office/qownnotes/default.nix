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
  version = "24.12.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz";
    hash = "sha256-OiaZmd50kOTJSJesBYFdjjKzNUc/m7XrU5S27z0mtAI=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
    pkg-config
    installShellFiles
    xvfb-run
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

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

  postInstall = ''
    installShellCompletion --cmd ${appname} \
      --bash <(xvfb-run $out/bin/${appname} --completion bash) \
      --fish <(xvfb-run $out/bin/${appname} --completion fish)
    installShellCompletion --cmd ${pname} \
      --bash <(xvfb-run $out/bin/${appname} --completion bash) \
      --fish <(xvfb-run $out/bin/${appname} --completion fish)
  ''
  # Create a lowercase symlink for Linux
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    ln -s $out/bin/${appname} $out/bin/${pname}
  ''
  # Wrap application for macOS as lowercase binary
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/${appname}.app $out/Applications
    makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
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
