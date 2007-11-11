# example tags:
# "-DNOW" (get current version)
# "-D2007-20-10" (get the last version before given date)
# "-r <tagname>" (get version by tag name)
{stdenv, cvs, nix}: {url, module, tag, sha256}:

stdenv.mkDerivation {
  name = "cvs-export";
  builder = ./builder.sh;
  buildInputs = [cvs nix];

  inherit url module tag sha256;
}
