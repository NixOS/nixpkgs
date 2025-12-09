{
  python3Packages,
  onionshare,
  replaceVars,
  meek,
  obfs4,
  snowflake,
  tor,
  qt5,
}:
python3Packages.buildPythonApplication rec {
  pname = "onionshare";
  inherit (onionshare)
    src
    version
    build-system
    pythonRelaxDeps
    ;
  pyproject = true;

  sourceRoot = "${src.name}/desktop";

  patches = [
    # hardcode store paths of dependencies
    (replaceVars ./fix-paths-gui.patch {
      inherit
        meek
        obfs4
        snowflake
        tor
        ;
      inherit (tor) geoip;
    })
  ];

  dependencies = with python3Packages; [
    onionshare
    pyside6
    python-gnupg
    qrcode
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  buildInputs = [ qt5.qtwayland ];

  postInstall = ''
    mkdir -p $out/share/{appdata,applications,icons}
    cp $src/desktop/org.onionshare.OnionShare.desktop $out/share/applications
    cp $src/desktop/org.onionshare.OnionShare.svg $out/share/icons
    cp $src/desktop/org.onionshare.OnionShare.appdata.xml $out/share/appdata
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false;

  pythonImportsCheck = [ "onionshare" ];

  meta = onionshare.meta // {
    mainProgram = "onionshare";
  };
}
