{stdenv, fetchurl, tcsh, libXaw, libXt, libX11}:
let
  s = # Generated upstream information
  rec {
    version = "3.3f";
    name = "otter";
    url = "http://www.cs.unm.edu/~mccune/otter/otter-${version}.tar.gz";
    sha256 = "16mc1npl7sk9cmqhrf3ghfmvx29inijw76f1b1lsykllaxjqqb1r";
  };
  buildInputs = [
    tcsh libXaw libXt libX11
  ];
in
stdenv.mkDerivation {
  name = "${s.name}-${s.version}";
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  hardeningDisable = [ "format" ];

  buildPhase = ''
    find . -name Makefile | xargs sed -i -e "s@/bin/rm@$(type -P rm)@g"
    find . -name Makefile | xargs sed -i -e "s@/bin/mv@$(type -P mv)@g"
    find . -perm -0100 -type f | xargs sed -i -e "s@/bin/csh@$(type -P csh)@g"
    find . -perm -0100 -type f | xargs sed -i -e "s@/bin/rm@$(type -P rm)@g"
    find . -perm -0100 -type f | xargs sed -i -e "s@/bin/mv@$(type -P mv)@g"

    sed -i -e "s/^XLIBS *=.*/XLIBS=-lXaw -lXt -lX11/" source/formed/Makefile 

    make all
    make -C examples all
    make -C examples-mace2 all
    make -C source/formed realclean
    make -C source/formed formed
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,share/otter}
    cp bin/* source/formed/formed "$out/bin/"
    cp -r examples examples-mace2 documents README* Legal Changelog Contents index.html "$out/share/otter/"
  '';

  meta = {
    inherit (s) version;
    description = "A reliable first-order theorem prover";
    license = stdenv.lib.licenses.publicDomain ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
