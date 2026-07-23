{
  lib,
  stdenv,
  backintime-common,
  python3,
  polkit,
  meld ? null,
  meldSupport ? true,
  kdePackages ? null,
  kompareSupport ? false,
  which,
  su,
  coreutils,
  util-linux,
  qt6,
  man,
  asciidoctor,
  keyringBackends ?
    ps: with ps; [
      secretstorage
      keyrings-alt
      keyring-pass
    ],
}:

let
  python' = python3.withPackages (
    ps:
    with ps;
    [
      pyqt6
      backintime-common
      dbus-python
      keyring
      packaging
    ]
    ++ (keyringBackends ps)
  );
  diffProgram =
    if meldSupport then
      "${lib.getBin meld}/bin"
    else if kompareSupport then
      "${lib.getBin kdePackages.kompare}/bin"
    else
      "";
in
stdenv.mkDerivation {
  inherit (backintime-common)
    version
    src
    installFlags
    meta
    dontAddPrefix
    ;

  pname = "backintime-qt";

  buildInputs = [
    python'
    backintime-common
    qt6.qtbase
    qt6.qtwayland
    man
    asciidoctor
  ];

  nativeBuildInputs = backintime-common.nativeBuildInputs or [ ] ++ [
    qt6.wrapQtAppsHook
  ];

  configureFlags = [ "--python=${lib.getExe python'}" ];

  preConfigure = ''
    patchShebangs --build updateversion.sh
    patchShebangs --build doc/manpages/build_manpages.sh
    cd qt
    substituteInPlace qttools_path.py \
      --replace-fail "Path(__file__).parent.parent" '"${backintime-common}/${python'.sitePackages}/backintime"'
  '';

  preFixup = ''
    wrapQtApp "$out/bin/backintime-qt" \
      --prefix PATH : "${lib.getBin backintime-common}/bin:$PATH" \
      --prefix PATH : "${diffProgram}:$PATH"

    substituteInPlace "$out/share/polkit-1/actions/net.launchpad.backintime.policy" \
      --replace-fail "/usr/bin/backintime-qt" "$out/bin/backintime-qt"

    substituteInPlace "$out/share/applications/backintime-qt-root.desktop" \
      --replace-fail "/usr/bin/backintime-qt" "backintime-qt"

    substituteInPlace "$out/share/backintime/qt/serviceHelper.py" \
      --replace-fail "'which'" "'${lib.getExe which}'" \
      --replace-fail "/bin/su" "${lib.getBin su}/bin/su" \
      --replace-fail "/usr/bin/backintime" "${lib.getExe backintime-common}" \
      --replace-fail "/usr/bin/nice" "${lib.getBin coreutils}/bin/nice" \
      --replace-fail "/usr/bin/ionice" "${lib.getBin util-linux}/bin/ionice"

    substituteInPlace "$out/share/dbus-1/system-services/net.launchpad.backintime.serviceHelper.service" \
      --replace-fail "/usr/share/backintime" "$out/share/backintime"

    substituteInPlace "$out/bin/backintime-qt_polkit" \
      --replace-fail "/usr/bin/backintime-qt" "$out/bin/backintime-qt"

    wrapProgram "$out/bin/backintime-qt_polkit" \
      --prefix PATH : "${lib.getBin polkit}/bin:$PATH"
  '';
}
