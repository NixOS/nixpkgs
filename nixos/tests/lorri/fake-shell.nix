derivation {
  system = builtins.currentSystem;
  name = "fake-shell";
  builder = ./builder.sh;
}
