{
  mkShell,
  stdenvNoCC,
}:

mkShell.override { stdenv = stdenvNoCC; }
