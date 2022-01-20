{
  # Nix
  lib,
  buildPythonApplication,
  fetchPypi,

  # Build inputs
  altair,
  astor,
  base58,
  blinker,
  boto3,
  botocore,
  click,
  cachetools,
  enum-compat,
  future,
  GitPython,
  jinja2,
  pillow,
  pyarrow,
  pydeck,
  pympler,
  protobuf,
  requests,
  setuptools,
  toml,
  tornado,
  tzlocal,
  validators,
  watchdog,
}:

let
  click_7 = click.overridePythonAttrs(old: rec {
    version = "7.1.2";
    src = old.src.override {
      inherit version;
      sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
    };
  });
in buildPythonApplication rec {
  pname = "streamlit";
  version = "1.2.0";
  format = "wheel"; # the only distribution available

  src = fetchPypi {
    inherit pname version format;
    sha256 = "1dzb68a8n8wvjppcmqdaqnh925b2dg6rywv51ac9q09zjxb6z11n";
  };

  propagatedBuildInputs = [
    altair
    astor
    base58
    blinker
    boto3
    botocore
    cachetools
    click_7
    enum-compat
    future
    GitPython
    jinja2
    pillow
    protobuf
    pyarrow
    pydeck
    pympler
    requests
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
