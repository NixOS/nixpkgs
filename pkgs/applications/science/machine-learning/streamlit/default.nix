{   lib, buildPythonApplication, fetchPypi
  , altair, astor, base58, blinker, boto3, botocore, click, enum-compat
  , future, pillow, protobuf, requests, toml, tornado, tzlocal, validators, watchdog
  , jinja2, setuptools
}:

buildPythonApplication rec {
  pname = "streamlit";
  version = "0.50.2";
  format = "wheel"; # the only distribution available

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1wymv7qckafs0p2jdjlxjaf1xrhm3iyd185jkldanbb0na5n3ndz";
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
    homepage = "https://streamlit.io/";
    description = "The fastest way to build custom ML tools";
    maintainers = with maintainers; [ yrashk ];
    license = licenses.asl20;
  };

}
