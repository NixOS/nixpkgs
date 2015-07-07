{stdenv, xenserver-buildroot, fetchurl, ocaml, cmdliner, cow, findlib, rpc, xmlm, python, setuptools}:

stdenv.mkDerivation {
  name = "xapi-storage-0.1.1";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/djs55/xapi-storage/archive/v0.1.1/xapi-storage-0.1.1.tar.gz";
    sha256 = "0z008sdj1nd4rfk39zzrv2p2pg5z94bglrj4gfdx6qwm13f2h5dm";
  };

  patches = [ "${xenserver-buildroot}/usr/share/buildroot/SOURCES/xapi-storage.patch" ];

  buildInputs = [ ocaml cow findlib rpc xmlm python setuptools ];

  propagatedBuildInputs = [ cmdliner ];

  configurePhase = ''
    make
    cd ocaml
    ocaml setup.ml -configure --prefix $out \
          --destdir $out
    '';

  buildPhase = ''
    ocaml setup.ml -build
    '';

  createFindlibDestdir = true;

  installPhase = ''
    export DESTDIR=$out
    ocaml setup.ml -install

    cd ../python
    mkdir -p $out/lib/${python.libPrefix}/site-packages/xapi
    cp __init__.py xapi.py d.py v.py p.py $out/lib/${python.libPrefix}/site-packages/xapi
    '';

  meta = {
    homepage = https://github.com/djs55/xapi-storage;
    description = "Xapi storage interface";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
