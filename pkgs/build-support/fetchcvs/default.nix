# example tags:
# date="2007-20-10"; (get the last version before given date)
# tag="<tagname>" (get version by tag name)
# If you don't specify neither one date="NOW" will be used (get latest)

{stdenvNoCC, cvs, openssh}:

{cvsRoot, module, tag ? null, date ? null, sha256
, name ? "${module}-${if tag != null then tag else if date != null then date else "NOW"}"
}:

stdenvNoCC.mkDerivation {
  builder = ./builder.sh;
  nativeBuildInputs = [cvs openssh];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit cvsRoot module sha256 tag date name;
}
