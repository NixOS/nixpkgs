{
  lib,
  fetchFromGitHub,
  python3Packages,
  cacert,
}:

python3Packages.buildPythonApplication rec {
  pname = "matrix-commander";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "8go";
    repo = "matrix-commander";
    rev = "v${version}";
    hash = "sha256-eNgnjErPi5q9yA/2iEg3+CoN2xbopmFOpbgU/7GhoAQ=";
  };

  pyproject = true;

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
    python3Packages.setuptools
    (python3Packages.matrix-nio.override { withOlm = true; })
    python3Packages.python-magic
    python3Packages.markdown
    python3Packages.pillow
    python3Packages.aiofiles
    python3Packages.notify2
    python3Packages.dbus-python
    python3Packages.pyxdg
    python3Packages.python-olm
    python3Packages.emoji
  ];

  meta = {
    description = "Simple but convenient CLI-based Matrix client app for sending and receiving";
    mainProgram = "matrix-commander";
    homepage = "https://github.com/8go/matrix-commander";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.seb314 ];
  };
}
