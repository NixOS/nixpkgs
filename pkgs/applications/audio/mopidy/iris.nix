{
  lib,
  python3Packages,
  fetchPypi,
  mopidy,
}:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.69.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PEAXnapiyxozijR053I7zQYRYLeDOV719L0QbO2r4r4=";
  };

  propagatedBuildInputs =
    [
      mopidy
    ]
    ++ (with python3Packages; [
      configobj
      requests
      tornado
    ]);

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/jaedb/Iris";
    description = "Fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
