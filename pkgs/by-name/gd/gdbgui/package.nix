{
  lib,
  python3Packages,
  fetchPypi,
  gdb,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gdbgui";
  version = "0.15.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-/HyFE0JnoN03CDyCQCo/Y9RyH4YOMoeB7khReIb8t7Y=";
  };

  postPatch = ''
    echo ${finalAttrs.version} > gdbgui/VERSION.txt
    # relax version requirements
    sed -i 's/==.*$//' requirements.txt
  '';

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [ gdb ];

  dependencies = with python3Packages; [
    eventlet
    flask-compress
    flask-socketio
    pygdbmi
    pygments
  ];

  postInstall = ''
    wrapProgram $out/bin/gdbgui \
      --prefix PATH : ${lib.makeBinPath [ gdb ]}
  '';

  # tests do not work without stdout/stdin
  doCheck = false;

  meta = {
    description = "Browser-based frontend for GDB";
    mainProgram = "gdbgui";
    homepage = "https://www.gdbgui.com/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      yrashk
      dump_stack
    ];
  };
})
