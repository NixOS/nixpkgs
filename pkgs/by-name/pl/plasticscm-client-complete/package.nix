{
  buildEnv,
  lib,
  plasticscm-client-core,
  plasticscm-client-gui,
}:
assert plasticscm-client-core.version == plasticscm-client-gui.version;
buildEnv {
  pname = "plasticscm-client-complete";
  inherit (plasticscm-client-core) version;
  name = "plasticscm-client-complete-${plasticscm-client-core.version}";

  paths = [
    plasticscm-client-core
    plasticscm-client-gui
  ];

  meta = {
    homepage = "https://www.plasticscm.com";
    description = "A Software Configuration Management system from Unity that tracks changes to source code and any digital asset over time";
    platforms = [ "x86_64-linux" ];
    mainProgram = "plasticgui";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
