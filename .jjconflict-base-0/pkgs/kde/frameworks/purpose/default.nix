{
  mkKdeDerivation,
  qtdeclarative,
  kaccounts-integration,
  kdeclarative,
  prison,
}:
mkKdeDerivation {
  pname = "purpose";

  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [
    kaccounts-integration
    kdeclarative
    prison
  ];
}
