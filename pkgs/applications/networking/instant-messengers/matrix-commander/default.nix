{ lib
, fetchFromGitHub
, buildPythonApplication
, cacert
, setuptools
, matrix-nio
, python-magic
, markdown
, pillow
, urllib3
, aiofiles
, notify2
, dbus-python
, pyxdg
, python-olm
}:

buildPythonApplication rec {
  pname = "matrix-commander";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "v${version}";
    sha256 = "sha256-/hNTaajZTyeIcGILIXqUVbBvZ8AUNZKBDsZ4Gr5RL2o=";
  };

  format = "pyproject";

  postPatch = ''
    # Dependencies already bundled with Python
    sed -i \
      -e '/uuid/d' \
      -e '/argparse/d' \
      -e '/asyncio/d' \
      -e '/datetime/d' \
      setup.cfg requirements.txt
  '';

  propagatedBuildInputs = [
    cacert
    setuptools
    matrix-nio
    python-magic
    markdown
    pillow
    urllib3
    aiofiles
    notify2
    dbus-python
    pyxdg
    python-olm
  ];

  meta = with lib; {
    description = "Simple but convenient CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.seb314 ];
  };
}
