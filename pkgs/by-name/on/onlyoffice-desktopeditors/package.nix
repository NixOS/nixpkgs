{
  lib,
  buildFHSEnv,
  # Alphabetic ordering below
  curl,
  onlyoffice-desktopeditors-unwrapped,
  noto-fonts-cjk-sans,
}:
# In order to download plugins, OnlyOffice uses /usr/bin/curl so we have to wrap it.
# Curl still needs to be in runtimeLibs because the library is used directly in other parts of the code.
# Fonts are also discovered by looking in /usr/share/fonts, so adding fonts to targetPkgs will include them
buildFHSEnv {
  inherit (onlyoffice-desktopeditors-unwrapped) pname version;

  targetPkgs = pkgs': [
    curl
    onlyoffice-desktopeditors-unwrapped
    noto-fonts-cjk-sans
  ];

  runScript = "/bin/onlyoffice-desktopeditors";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${onlyoffice-desktopeditors-unwrapped}/share/icons $out/share
    cp -r ${onlyoffice-desktopeditors-unwrapped}/share/applications $out/share
    substituteInPlace $out/share/applications/onlyoffice-desktopeditors.desktop \
        --replace-fail "/usr/bin/onlyoffice-desktopeditors" "$out/bin/onlyoffice-desktopeditors"
  '';

  passthru.unwrapped = onlyoffice-desktopeditors-unwrapped;

  meta = {
    description = "Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents";
    homepage = "https://www.onlyoffice.com/";
    downloadPage = "https://github.com/ONLYOFFICE/DesktopEditors/releases";
    changelog = "https://github.com/ONLYOFFICE/DesktopEditors/blob/master/CHANGELOG.md";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nh2
      gtrunsec
    ];
  };
}
