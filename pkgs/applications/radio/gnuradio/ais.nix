{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, gnuradio
, makeWrapper
, cppunit
, gr-osmosdr
, log4cpp
, pythonSupport ? true
, python
, swig
, fetchpatch
}:

stdenv.mkDerivation {
  pname = "gr-ais";
  version = "2015-12-20";

  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    rev = "cdc1f52745853f9c739c718251830eb69704b26e";
    sha256 = "1vl3kk8xr2mh5lf31zdld7yzmwywqffffah8iblxdzblgsdwxfl6";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/bistromath/gr-ais/commit/8502d0252a2a1a9b8d1a71795eaeb5d820684054.patch";
      sha256 = "1cwalphldvf6dbhzwz1gi53z0cb4921qsvlz4138q7m6dxccvssg";
    })
  ];

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];
  buildInputs = [ boost gnuradio cppunit gr-osmosdr log4cpp ]
    ++ lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for ais";
    homepage = "https://github.com/bistromath/gr-ais";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
