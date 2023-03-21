{ lib, symlinkJoin, kdevelop-unwrapped, plugins ? null }:

symlinkJoin {
  name = "kdevelop-with-plugins";

  paths = [ kdevelop-unwrapped ] ++ (lib.optionals (plugins != null) plugins);
}
