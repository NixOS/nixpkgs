{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "whitey";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fjas9a2xbhd5p95k82bl54y2f9qnrda4s7wb5igarkawbrcvi9m";
  };

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Command-line YouTube client";
    homepage = "https://github.com/rjw57/yt";
    longDescription = ''
      yt is a command-line front-end to YouTube
      which allows you to browse YouTube videos and play them
      directly from the command-line
    '';
    license = licenses.asl20;
  };
}
