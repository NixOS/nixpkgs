{
  mkDerivation,
  libdevctl,
}:
mkDerivation {
  path = "usr.sbin/devctl";
  outputs = [
    "out"
    "debug"
  ];
  buildInputs = [ libdevctl ];
  meta.mainProgram = "devctl";
}
