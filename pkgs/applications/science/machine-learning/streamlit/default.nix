{ lib
, altair
, blinker
, buildPythonApplication
, cachetools
, click
, fetchPypi
, gitpython
, importlib-metadata
, jinja2
, pillow
, protobuf3
, pyarrow
, pydeck
, pympler
, requests
, rich
, semver
, setuptools
, toml
, tornado
, tzlocal
, validators
, watchdog
}:

buildPythonApplication rec {
  pname = "streamlit";
  version = "1.21.0";
  format = "wheel"; # source currently requires pipenv

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-BYYlmJUqkSbhZlLKpbyI7u6nsnc68lLi2szxyEzqrvQ=";
  };

  propagatedBuildInputs = [
    altair
    blinker
    cachetools
    click
    gitpython
    importlib-metadata
    jinja2
    pillow
    protobuf3
    pyarrow
    pydeck
    pympler
    requests
    rich
    semver
    setuptools
    toml
    tornado
    tzlocal
    validators
    watchdog
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
