{stdenv, curl}: {url, md5}:

# Note that `curl' may be `null', in case of the native stdenv.

stdenv.mkDerivation {
  name = baseNameOf (toString url);
  builder = ./builder.sh;
  buildInputs = [curl];
  id = md5;
  inherit url md5;
}
