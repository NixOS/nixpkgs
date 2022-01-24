{ symlinkJoin, kdevelop-unwrapped, plugins ? null }:

symlinkJoin {
  name = "kdevelop-with-plugins";

  paths = [ kdevelop-unwrapped ] ++ (if plugins != null then plugins else []);
}
