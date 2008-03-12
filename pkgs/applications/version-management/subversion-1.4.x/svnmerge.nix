{subversion, stdenv, python, shebangfix }:
stdenv.mkDerivation {
  name = "${subversion.name}-svnmerge";

  src = subversion.src;

  phases = "unpackPhase buildPhase";

  buildInputs = [ shebangfix python ];

  buildPhase = "
    ensureDir \$out/bin
    t=\$out/bin/svnmerge.py
    cp contrib/client-side/svnmerge.py \$t
    chmod +x \$t
    shebangfix  \$t
  ";

  meta = subversion.meta // { 
      description = "installs the contrib tool svnmerge.py";
  };
}
