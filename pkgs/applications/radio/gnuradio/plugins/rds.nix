{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, boost
, gnuradio
, python
, swig
}:

let
  version = if gnuradio.branch == "3.7" then "1.1.0" else "3.8.0";
  src_hash = if gnuradio.branch == "3.7" then
   "0jkzchvw0ivcxsjhi1h0mf7k13araxf5m4wi5v9xdgqxvipjzqfy"
  else # if gnuradio.branch == "3.8" then
   "16k3zl8vc2rpkc9mhd7xbk2705knxzc3j8j0iqvb58wvxlk8n8pv"
  ;
in

stdenv.mkDerivation rec {
  pname = "gr-rds";
  inherit version;

  src = fetchFromGitHub {
    owner = "bastibl";
    repo = "gr-rds";
    rev = "v${version}";
    sha256 = src_hash;
  };

  nativeBuildInputs = [
    pkgconfig
    python
    swig
  ];
  buildInputs = [
    cmake
    boost
    gnuradio
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for radio data system";
    homepage = "https://github.com/bastibl/gr-rds";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
