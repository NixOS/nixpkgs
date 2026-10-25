{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  desktop-file-utils,
  electron_44,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "notion-electron";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "anechunaev";
    repo = "notion-electron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hgEseSpGoGiqpCHEiIPzEZPkCpk/iQi3vPySnkdSrwA=";
  };

  npmDepsHash = "sha256-7h/aKuMinm5VjGOHX8gStPc/IsOpWm5TEg/3c1l7M18=";

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    desktop-file-utils
  ];

  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/icons/hicolor/256x256/apps
    mkdir -p $out/share/applications

    cp notion-electron.desktop $out/share/applications/

    cp assets/icons/desktop.png $out/share/icons/hicolor/256x256/apps/notion-electron.png

    cp -r assets $out/lib/node_modules/notion-electron/

    desktop-file-edit \
      --set-key="Exec" --set-value="notion-electron %U" \
      $out/share/applications/notion-electron.desktop

    # Disable update functionality as it will be handled via nixpkgs
    makeWrapper ${electron_44}/bin/electron $out/bin/notion-electron \
              --add-flags '--disable-update-functionality' \
              --add-flags $out/lib/node_modules/notion-electron
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enhanced Notion Desktop client for Linux";
    homepage = "https://github.com/anechunaev/notion-electron";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Mowerick ];
    platforms = lib.platforms.linux;
    mainProgram = "notion-electron";
  };
})
