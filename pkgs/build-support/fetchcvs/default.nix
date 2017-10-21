# example tags:
# date="2007-20-10"; (get the last version before given date)
# tag="<tagname>" (get version by tag name)
# If you don't specify neither one date="NOW" will be used (get latest)

{stdenv, cvs}:

{cvsRoot, module, tag ? null, date ? null, sha256}:

stdenv.mkDerivation {
  name = "cvs-export";
  builder = ./builder.sh;
  buildInputs = [cvs];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;
  
  inherit cvsRoot module sha256 tag date;
}
