{
  lib,
  fetchFromGitHub,
  buildPythonApplication,
  cacert,
  setuptools,
  matrix-nio,
  python-magic,
  markdown,
  pillow,
  aiofiles,
  notify2,
  dbus-python,
  pyxdg,
  python-olm,
  emoji,
}:

buildPythonApplication rec {
  pname = "matrix-commander";
  version = "8.0.4";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "v${version}";
    hash = "sha256-JZcdAo6d7huwDQ9hJE8oT5FH0ZQjg0DhoglOkhOyk1o=";
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
    (matrix-nio.override { withOlm = true; })
    python-magic
    markdown
    pillow
    aiofiles
    notify2
    dbus-python
    pyxdg
    python-olm
    emoji
  ];

  meta = with lib; {
    description = "Simple but convenient CLI-based Matrix client app for sending and receiving";
    mainProgram = "matrix-commander";
    homepage = "https://github.com/8go/matrix-commander";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.seb314 ];
  };
}
