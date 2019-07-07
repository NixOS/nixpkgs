{ stdenv, fetchurl, apfel, apfelgrid, applgrid, blas, gfortran, lhapdf, liblapack, libyaml, lynx, mela, root5, qcdnum, which }:

stdenv.mkDerivation rec {
  name = "xfitter-${version}";
  version = "2.0.0";

  src = fetchurl {
    name = "${name}.tgz";
    url = "https://www.xfitter.org/xFitter/xFitter/DownloadPage?action=AttachFile&do=get&target=${name}.tgz";
    sha256 = "0j47s8laq3aqjlgp769yicvgyzqjb738a3rqss51d9fjrihi2515";
  };

  patches = [
    ./undefined_behavior.patch
  ];

  CXXFLAGS = "-Werror=return-type";

  preConfigure =
  # Fix F77LD to workaround for a following build error:
  #
  #   gfortran: error: unrecognized command line option '-stdlib=libc++'
  #
    stdenv.lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/Makefile.in \
        --replace "F77LD = \$(F77)" "F77LD = \$(CXXLD)" \
    '';

  configureFlags = [
    "--enable-apfel"
    "--enable-apfelgrid"
    "--enable-applgrid"
    "--enable-mela"
    "--enable-lhapdf"
  ];

  nativeBuildInputs = [ gfortran which ];
  buildInputs =
    [ apfel apfelgrid applgrid blas lhapdf liblapack mela root5 qcdnum ]
    # pdf2yaml requires fmemopen and open_memstream which are not readily available on Darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) libyaml
    ;
  propagatedBuildInputs = [ lynx ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "The xFitter project is an open source QCD fit framework ready to extract PDFs and assess the impact of new data";
    license     = licenses.gpl3;
    homepage    = https://www.xfitter.org/xFitter;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
