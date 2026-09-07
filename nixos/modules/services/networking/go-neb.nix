{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "go-neb" ] ''
      The Go-NEB project was discontinued by Matrix.org and archived in June
      2023. Use matrix-hookshot or another maintained Matrix bot instead.
    '')
  ];
}
