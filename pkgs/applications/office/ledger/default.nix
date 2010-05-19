# TODO: fix a problem with patchelf(?)

{stdenv, fetchurl, emacs, gmp, pcre}:

let

  pname = "ledger";
  version = "2.6.1";
  name = "${pname}-${version}";

in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "96830d77d3aa6bf6c5778f5dd52169f9b5203fb7daad0e12831abeb35b14f27a";
  };

  buildInputs = [ emacs gmp pcre ];

  patches = [ ./const.patch ];

  # Something goes wrong with pathelf...
  # this is a small workaround: adds a small shell script for
  # setting LD_LIBRARY_PATH
  postInstall = ''
    cd $out/bin
    mv ledger ledger.bin
    echo "#!/bin/sh" > ledger
    echo "LD_LIBRARY_PATH=$out/lib $out/bin/ledger.bin "'"$@"' >> ledger
    chmod +x ledger
  '';

  meta = {
    description =
     "A double-entry accounting system with a command-line reporting interface";
    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';
    homepage = http://wiki.github.com/jwiegley/ledger;
    license = "BSD";
  };
}
