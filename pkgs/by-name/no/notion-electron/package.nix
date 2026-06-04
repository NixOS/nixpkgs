{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  desktop-file-utils,
  electron,
}:

buildNpmPackage (finalAttrs: {
  pname = "notion-electron";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "anechunaev";
    repo = "notion-electron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pFPGkE2XwlBEbitl0OatfQAht1TmcErnVMZCFYjwZ8I=";
  };

  npmDepsHash = "sha256-EMY7Y95bp12+jLn5Wv6x134utA0LFqldP/d8zHrs/RI=";

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    desktop-file-utils
  ];

  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/notion-electron
    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/applications

    cp -r . $out/lib/notion-electron/

    cp notion-electron.desktop $out/share/applications/
    cp notion-electron.png $out/share/icons/hicolor/256x256/apps/

    desktop-file-edit \
      --set-key="Exec" --set-value="notion-electron %U" \
      $out/share/applications/notion-electron.desktop

    makeWrapper ${electron}/bin/electron $out/bin/notion-electron \
              --add-flags "$out/lib/notion-electron"

    runHook postInstall
  '';

  meta = {
    description = "Enhanced Notion Desktop client for Linux";
    homepage = "https://github.com/anechunaev/notion-electron";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Mowerick ];
    platforms = lib.platforms.linux;
    mainProgram = "notion-electron";
  };
})
