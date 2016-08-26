{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, gnuradio
, makeWrapper, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-rds-${version}";
  version = "2016-08-27";

  src = fetchFromGitHub {
    owner = "bastibl";
    repo = "gr-rds";
    rev = "5246b75180808d47f321cb26f6c16d7c7a7af4fc";
    sha256 = "008284ya464q4h4fd0zvcn6g7bym231p8fl3kdxncz9ks4zsbsxs";
  };

  buildInputs = [
    cmake pkgconfig boost gnuradio makeWrapper
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnuradio block for radio data system";
    homepage = https://github.com/bastibl/gr-rds;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
