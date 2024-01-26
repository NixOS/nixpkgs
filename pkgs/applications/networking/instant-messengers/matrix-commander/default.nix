{ lib
, fetchFromGitHub
, buildPythonApplication
, cacert
, setuptools
, matrix-nio
, python-magic
, markdown
, pillow
, aiofiles
, notify2
, dbus-python
, pyxdg
, python-olm
, emoji
}:

buildPythonApplication rec {
  pname = "matrix-commander";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "v${version}";
    hash = "sha256-qL6ARkAWu0FEuYK2e9Z9hMSfK4TW0kGgoIFUfJ8Dgwk=";
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
    aiofiles
    notify2
    dbus-python
    pyxdg
    python-olm
    emoji
  ] ++ matrix-nio.optional-dependencies.e2e;

  meta = with lib; {
    description = "Simple but convenient CLI-based Matrix client app for sending and receiving";
    homepage = "https://github.com/8go/matrix-commander";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.seb314 ];
  };
}
