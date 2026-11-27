{ transmission_4, noMaintainersNorDependents }:

noMaintainersNorDependents (
  transmission_4.override {
    installLib = true;
    enableDaemon = false;
    enableCli = false;
  }
)
