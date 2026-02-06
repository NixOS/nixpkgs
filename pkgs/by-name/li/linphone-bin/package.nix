{
  lib,
  appimageTools,
  fetchurl,
  testers,
  linphone-bin,
  xvfb-run,
  dbus,
}:
let
  pname = "linphone-bin";
  version = "6.1.0";

  src = fetchurl {
    url = "https://download.linphone.org/releases/linux/app/Linphone-${version}-x86_64.AppImage";
    hash = "sha256-z3JEtJDIjomuDYusmJShPuKJlkxkk1/HWP5KC/OamWc=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -m 444 -D ${appimageContents}/usr/share/applications/linphone.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail "Name=Linphone" "Name=Linphone (AppImage)" \
        --replace-fail "Exec=linphone" "Exec=${pname}"

      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/scalable/apps/linphone.svg \
        $out/share/icons/hicolor/scalable/apps/linphone.svg
    '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = linphone-bin;
      command = ''
        export PATH=${lib.makeBinPath [ dbus ]}:$PATH
        export HOME=$TMPDIR
        ${xvfb-run}/bin/xvfb-run dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf -- linphone-bin -v
      '';
      version = lib.head (lib.splitString "-" version);
    };
  };

  meta = {
    description = "Official Linphone desktop application (AppImage binary)";
    homepage = "https://www.linphone.org/";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ nivalux ];
    mainProgram = "linphone-bin";
  };
}
