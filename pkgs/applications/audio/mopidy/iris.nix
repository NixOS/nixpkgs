{ lib, stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.54.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0qnshn77dv7fl6smwnpnbq67mbc1vic9gf85skiqnqy8v8w5829f";
  };

  propagatedBuildInputs = [
    mopidy
  ] ++ (with python3Packages; [
    configobj
    requests
    tornado
  ]);

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jaedb/Iris";
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
