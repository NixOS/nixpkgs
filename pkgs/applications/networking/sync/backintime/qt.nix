{ lib, mkDerivation, backintime-common, python3, polkit, which, su, coreutils, util-linux }:

let
  python' = python3.withPackages (ps: with ps; [ pyqt5 backintime-common packaging ]);
in
mkDerivation {
  inherit (backintime-common)
    version src installFlags meta dontAddPrefix nativeBuildInputs;

  pname = "backintime-qt";

  buildInputs = [ python' backintime-common ];

  configureFlags = [ "--python=${lib.getExe python'}" ];

  preConfigure = ''
    cd qt
    substituteInPlace qttools_path.py \
      --replace-fail "__file__, os.pardir, os.pardir" '"${backintime-common}/${python'.sitePackages}/backintime"'
  '';

  preFixup = ''
    wrapQtApp "$out/bin/backintime-qt" \
      --prefix PATH : "${lib.getBin backintime-common}/bin:$PATH"

    substituteInPlace "$out/share/polkit-1/actions/net.launchpad.backintime.policy" \
      --replace-fail "/usr/bin/backintime-qt" "$out/bin/backintime-qt"

    substituteInPlace "$out/share/applications/backintime-qt-root.desktop" \
      --replace-fail "/usr/bin/backintime-qt" "backintime-qt"

    substituteInPlace "$out/share/backintime/qt/serviceHelper.py" \
      --replace-fail "'which'" "'${lib.getBin which}/bin/which'" \
      --replace-fail "/bin/su" "${lib.getBin su}/bin/su" \
      --replace-fail "/usr/bin/backintime" "${lib.getBin backintime-common}/bin/backintime" \
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
