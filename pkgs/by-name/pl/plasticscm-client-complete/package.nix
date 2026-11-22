{
  buildEnv,
  lib,
  plasticscm-client-core,
  plasticscm-client-gui,
}:
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
    description = "SCM by Unity for game development";
    platforms = [ "x86_64-linux" ];
    mainProgram = "plasticgui";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ musjj ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
