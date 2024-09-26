{
  lib,
  fetchPypi,
  python3,
  python3Packages,
  ripgrep,
}:

python3Packages.buildPythonPackage rec {
  pname = "seagoat";
  version = "0.48.4";
  pyproject = true;

  dependencies = with python3.pkgs; [
    poetry-core
    appdirs
    blessed
    chardet
    flask
    deepmerge
    chromadb
    gitpython
    jsonschema
    pygments
    requests
    nest-asyncio
    waitress
    psutil
    stop-words
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MnRUl6hDfl1NGcV2cXZO+WxVqWUD4TmhP+KkMEYVve8=";
  };

  stop-words = python3Packages.buildPythonApplication rec {
    pname = "stop-words";
    version = "2018.7.23";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-bfOtX13ml9qkN+REXIbHNgTmvBON0NwPrFVmSqTmsD4=";
    };
    doCheck = false;
  };

  postInstall = ''
    wrapProgram $out/bin/seagoat-server \
      --prefix PATH : "${ripgrep}/bin"
  '';

  meta = {
    description = "Local-first semantic code search engine";
    homepage = "https://kantord.github.io/SeaGOAT/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lavafroth ];
    mainProgram = "seagoat";
  };
}
