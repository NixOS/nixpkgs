{ python3Packages }:

with python3Packages;
toPythonApplication (dvc.override {
  enableGoogle = true;
  enableAWS = true;
  enableAzure = true;
  enableSSH = true;
})
