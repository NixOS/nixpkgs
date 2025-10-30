{
  python3Packages,
  enableGoogle ? false,
  enableAWS ? false,
  enableAzure ? false,
  enableSSH ? false,
}:

let
  dvc = python3Packages.dvc.override {
    inherit
      enableGoogle
      enableAWS
      enableAzure
      enableSSH
      ;
  };
in
python3Packages.toPythonApplication dvc
