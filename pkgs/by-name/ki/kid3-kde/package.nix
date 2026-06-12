{
  kid3,
  noMaintainersNorDependents,
}:
noMaintainersNorDependents (
  kid3.override {
    withCLI = true;
    withKDE = true;
    withQt = false;
  }
)
