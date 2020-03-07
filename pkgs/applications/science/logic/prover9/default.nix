{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "prover9-2009-11a";

  src = fetchurl {
    url = https://www.cs.unm.edu/~mccune/mace4/download/LADR-2009-11A.tar.gz;
    sha256 = "1l2i3d3h5z7nnbzilb6z92r0rbx0kh6yaxn2c5qhn3000xcfsay3";
  };

  hardeningDisable = [ "format" ];

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

  buildFlags = [ "all" ];

  checkPhase = "make test1";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  meta = {
    homepage = https://www.cs.unm.edu/~mccune/mace4/;
    license = "GPL";
    description = "Automated theorem prover for first-order and equational logic";
    longDescription = ''
      Prover9 is a resolution/paramodulation automated theorem prover
      for first-order and equational logic. Prover9 is a successor of
      the Otter Prover. This is the LADR command-line version.
    '';
    platforms = stdenv.lib.platforms.linux;
    maintainers = [];
  };
}
