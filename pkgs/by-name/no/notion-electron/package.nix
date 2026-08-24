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
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "anechunaev";
    repo = "notion-electron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Or0Dd9ZfKfyi6DbDHOgCK1zz+PUHeONCfb53C1dIqS8=";
  };

  npmDepsHash = "sha256-39zUDddZVK5XwKJeBfmVDNHPkcLJgRcXJX9c3RYftlA";

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

    desktop-file-edit \
      --set-key="Exec" --set-value="notion-electron %U" \
      $out/share/applications/notion-electron.desktop

    # Disable update functionality as it will be handled via nixpkgs
    makeWrapper ${electron}/bin/electron $out/bin/notion-electron \
              --add-flags '--disable-update-functionality' \
              --add-flags $out/lib/node_modules/notion-electron
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
