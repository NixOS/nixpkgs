{ stdenv, fetchgit, cmake, makeWrapper, perl, GetoptTabular, MNI-Perllib, libminc }:

stdenv.mkDerivation rec {
  pname = "mni_autoreg";
  name  = "${pname}-0.99.70";

  src = fetchgit {
    url = "https://github.com/BIC-MNI/${pname}.git";
    rev = "a4367b82012fe3b40e794fc1eb6c3c86e86148bf";
    sha256 = "1j5vk7hf03y38fwb5klfppk3g4d2hx1fg3ikph2708pnssmim2qr";
  };

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ libminc ];
  propagatedBuildInputs = [ perl GetoptTabular MNI-Perllib ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/" "-DBUILD_TESTING=FALSE" ];
  # testing broken: './minc_wrapper: Permission denied' from Testing/ellipse0.mnc

  postFixup = ''
    for prog in autocrop mritoself mritotal xfmtool; do
      echo $out/bin/$prog
      wrapProgram $out/bin/$prog --prefix PERL5LIB : $PERL5LIB;
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/BIC-MNI/mni_autoreg;
    description = "Tools for automated registration using the MINC image format";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
  };
}

