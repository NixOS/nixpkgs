{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  libsForQt5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "2048-qt";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "xiaoyong";
    repo = "2048-Qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wA4MZlox3X5OKGR9JQ12+JLF1rz8AAJDcxWq7TQSx7k=";
  };

  postPatch = ''
    substituteInPlace res/2048-qt.desktop \
      --replace-fail "#!/usr/bin/env xdg-open" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    libsForQt5.qmake
    libsForQt5.qtdeclarative
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtquickcontrols
  ];

  installPhase = ''
    runHook preInstall

  ''
  + (
    if stdenv.isDarwin then
      ''
        mkdir -p "$out/Applications" "$out/bin"
        cp -r 2048-qt.app "$out/Applications"
        ln -s "$out/Applications/2048-qt.app/Contents/MacOS/2048-qt" "$out/bin"
      ''
    else
      ''
        install -Dm755 2048-qt -t "$out/bin"
      ''
  )
  + ''
    install -Dm644 res/2048-qt.desktop -t "$out/share/applications"

    for p in res/icons/*/apps/2048-qt.*; do
      install -Dm644 "$p" "$out/share/icons/hicolor/''${p#res/icons/}"
    done

    installManPage res/man/2048-qt.6

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The 2048 number game implemented in Qt";
    homepage = "https://github.com/xiaoyong/2048-Qt";
    changelog = "https://github.com/xiaoyong/2048-Qt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "2048-qt";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
