{
  python3Packages,
  onionshare,
  replaceVars,
  meek,
  obfs4,
  snowflake,
  tor,
  fetchpatch,
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

    # https://github.com/onionshare/onionshare/pull/1903
    (fetchpatch {
      url = "https://github.com/onionshare/onionshare/pull/1903/commits/f20db8fcbd18e51b58814ae8f98f3a7502b4f456.patch";
      stripLen = 1;
      hash = "sha256-wfIjdPhdUYAvbK5XyE1o2OtFOlJRj0X5mh7QQRjdyP0=";
    })

    # Remove distutils for Python 3.12 compatibility
    # https://github.com/onionshare/onionshare/pull/1907
    (fetchpatch {
      url = "https://github.com/onionshare/onionshare/commit/1fb1a470df20d8a7576c8cf51213e5928528d59a.patch";
      includes = [ "onionshare/update_checker.py" ];
      stripLen = 1;
      hash = "sha256-mRRj9cALZVHw86CgU17sp9EglKhkRRcGfROyQpsXVfU=";
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
