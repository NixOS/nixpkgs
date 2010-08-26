{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "prover9";

  src = fetchurl {
    url = http://www.cs.unm.edu/~mccune/mace4/download/LADR-2009-11A.tar.gz;
    sha256 = "1l2i3d3h5z7nnbzilb6z92r0rbx0kh6yaxn2c5qhn3000xcfsay3";
  };

  phases = "unpackPhase patchPhase buildPhase installPhase";

  patchPhase = ''
    RM=$(type -tp rm)
    MV=$(type -tp mv)
    CP=$(type -tp cp)
    for f in Makefile */Makefile; do
      substituteInPlace $f --replace "/bin/rm" "$RM" \
        --replace "/bin/mv" "$MV" \
        --replace "/bin/cp" "$CP";
    done
  '';

  buildFlags = "all";

  installPhase = ''
    ensureDir $out/bin
    cp bin/* $out/bin
  '';

  meta = {
    homepage = "http://www.cs.unm.edu/~mccune/mace4/";
    license = "GPL";
    description = "Prover9 is an automated theorem prover for first-order and equational logic.";

    longDescription = ''
      Prover9 is a resolution/paramodulation automated theorem prover
      for first-order and equational logic. Prover9 is a successor of
      the Otter Prover. This is the LADR command-line version.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [];
  };
}
