{   lib, buildPythonApplication, fetchPypi
  , altair, astor, base58, blinker, click, cachetools, GitPython, pillow, protobuf
  , pyarrow, pydeck, pympler, requests, toml, tornado, tzlocal, validators, watchdog
  , jinja2, setuptools 
}:

buildPythonApplication rec {
  pname = "streamlit";
  version = "1.2.0";
  format = "wheel"; # the only distribution available

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1dzb68a8n8wvjppcmqdaqnh925b2dg6rywv51ac9q09zjxb6z11n";
  };

  postPatch = ''
    chmod u+rwx -R ./dist
    pushd dist
    wheel unpack --dest unpacked ./*.whl
    pushd unpacked/${pname}-${version}

    substituteInPlace ${pname}-${version}.dist-info/METADATA \
      --replace "click (<8.0,>=7.0)" "click" 

    popd
    wheel pack ./unpacked/${pname}-${version}
    popd
  '';

  propagatedBuildInputs = [
    altair astor base58 blinker click cachetools GitPython pillow protobuf
    pyarrow pydeck pympler requests toml tornado tzlocal validators watchdog
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
