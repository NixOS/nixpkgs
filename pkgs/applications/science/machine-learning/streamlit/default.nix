{   lib, buildPythonApplication, fetchPypi
  , altair, astor, base58, blinker, boto3, botocore, click, enum-compat
  , future, pillow, protobuf, requests, toml, tornado, tzlocal, validators, watchdog
  , jinja2, setuptools
}:

buildPythonApplication rec {
  pname = "streamlit";
  version = "0.49.0";
  format = "wheel"; # the only distribution available

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1g12z93yh85vcgf3g9banshllr5fhz8i4f9llymcnk6mafvcsiv7";
  };

  propagatedBuildInputs = [
    altair astor base58 blinker boto3 botocore click enum-compat
    future pillow protobuf requests toml tornado tzlocal validators watchdog
    jinja2 setuptools
  ];

  postInstall = ''
      rm $out/bin/streamlit.cmd # remove windows helper
  '';

  meta = with lib; {
    homepage = https://streamlit.io/;
    description = "The fastest way to build custom ML tools";
    maintainers = with maintainers; [ yrashk ];
    license = licenses.asl20;
  };

}
