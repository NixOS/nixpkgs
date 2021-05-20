{ lib
, python3
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "maubot";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m2n9ly38gqf301qpw38fc6dqx78amf9i2lkyyifvzr1kvky4gv9";
  };

  propagatedBuildInputs = [
    aiohttp
    alembic
    attrs
    bcrypt
    click
    colorama
    CommonMark
    jinja2
    mautrix
    packaging
    pyinquirer
    ruamel_yaml
    sqlalchemy
    yarl
  ];

  checkPhase = ''
    $out/bin/mbc --help > /dev/null
  '';

  pythonImportsCheck = [
    "maubot"
  ];

  meta = with lib; {
    description = "A plugin-based Matrix bot system written in Python";
    homepage = "https://github.com/maubot/maubot";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
