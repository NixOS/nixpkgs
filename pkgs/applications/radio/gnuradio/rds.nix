{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, gnuradio, log4cpp
, makeWrapper, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  pname = "gr-rds";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bastibl";
    repo = "gr-rds";
    rev = "v${version}";
    sha256 = "0jkzchvw0ivcxsjhi1h0mf7k13araxf5m4wi5v9xdgqxvipjzqfy";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost gnuradio makeWrapper log4cpp
  ] ++ lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for radio data system";
    homepage = "https://github.com/bastibl/gr-rds";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
