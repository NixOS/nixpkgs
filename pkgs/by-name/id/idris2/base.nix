{ mkPrelude, prelude }:
mkPrelude {
  name = "base";
  dependencies = [ prelude ];
}
