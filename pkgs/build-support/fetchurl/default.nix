{stdenv, curl}: {url, md5}:

# Note that `curl' may be `null', in case of the native stdenv.

derivation {
  name = baseNameOf (toString url);
  system = stdenv.system;
  builder = ./builder.sh;
  buildInputs = [curl];
  id = md5;
  inherit stdenv url md5;
}
