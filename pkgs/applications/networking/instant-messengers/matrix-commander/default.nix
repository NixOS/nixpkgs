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
, python-olm
}:

buildPythonApplication {
  pname = "matrix-commander";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "77cf433af0d2e63a88b8914026795a0da5486b77";
    sha256 = "sha256-qUyaN0syP2lLRJLCAD5nCWfwR/CW4t/g40a8xDYseIg=";
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

    # Dependencies not correctly detected
    sed -i \
      -e '/dbus-python/d' \
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
