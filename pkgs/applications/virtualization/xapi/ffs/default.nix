{stdenv, fetchurl, ocaml, ocamlscript, xapi-storage, cmdliner, cohttp, cstruct, findlib, re, rpc, xcp-idl}:

stdenv.mkDerivation {
  name = "ffs-0.10.0";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/xapi-project/ffs/archive/v0.10.0/ffs-0.10.0.tar.gz";
    sha256 = "0mf968qc55x0bffrmzr0vx8w6yam10n6pmimaw1qsrcgisf4x4m0";
  };

  buildInputs = [ ocaml ocamlscript xapi-storage cmdliner cohttp cstruct findlib re rpc xcp-idl ];

  configurePhase = "true";

  buildPhase = ''
    ./volume/SR.ls --help=groff
    '';

  installPhase = ''
    cd volume
    DESTDIR=$out SCRIPTDIR=/libexec/xapi-storage-script/volume/org.xen.xcp.storage.ffs make install
    cd ../datapath
    DESTDIR=$out SCRIPTDIR=/libexec/xapi-storage-script/datapath/file make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/ffs;
    description = "Simple flat file storage manager for the xapi toolstack";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
