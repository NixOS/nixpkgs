{ stdenv, pythonPackages, mopidy, mopidy-local-images }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.33.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0g00rjkmsnza4gjjdm0cwrpw3gqvmjj58157dvrh7f8k7j0gdvdm";
  };

  propagatedBuildInputs = [
    mopidy
    mopidy-local-images
  ] ++ (with pythonPackages; [
    configobj
    requests
    tornado_4
  ]);

  # no tests implemented
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jaedb/Iris;
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
