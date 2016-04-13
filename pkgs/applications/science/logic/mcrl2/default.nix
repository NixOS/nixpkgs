{stdenv, fetchurl, xlibs, cmake, subversion, mesa, qt5, boost,
 python27, python27Packages}:

stdenv.mkDerivation rec {
  version = "201409.1";
  build_nr = "13892";
  name = "mcrl2-${version}";

  src = fetchurl {
    url = "http://www.mcrl2.org/download/devel/mcrl2-${version}.${build_nr}.tar.gz";
    sha256 = "0cknpind6rma12q93rbm638ijhy8sj8nd20wnw8l0f651wm0x036";
  };

  buildInputs = [ xlibs.libX11 cmake subversion mesa qt5.qtbase boost
                  python27 python27Packages.pyyaml python27Packages.psutil ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A toolset for model-checking concurrent systems and protocols";
    longDescription = ''
      A formal specification language with an associated toolset,
      that can be used for modelling, validation and verification of
      concurrent systems and protocols
    '';
    homepage = http://www.mcrl2.org/;
    license = licenses.boost;
    maintainers = with maintainers; [ moretea ];
    platforms = platforms.unix;
  };
}
