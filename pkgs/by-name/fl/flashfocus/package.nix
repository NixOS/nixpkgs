{
  lib,
  python3Packages,
  fetchPypi,
  netcat-openbsd,
  procps,
  bash,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.4.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O6jRQ6e96b8CuumTD6TGELaz26No7WFZgGSnNSlqzuE=";
  };

  postPatch = ''
    substituteInPlace bin/nc_flash_window \
      --replace-fail "nc" "${lib.getExe netcat-openbsd}"

    substituteInPlace src/flashfocus/util.py \
      --replace-fail "pidof" "${lib.getExe' procps "pidof"}"
  '';

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  buildInputs = [
    bash
  ];

  pythonRelaxDeps = [
    "pyyaml"
    "xcffib"
    "cffi"
  ];

  propagatedBuildInputs = with python3Packages; [
    i3ipc
    xcffib
    click
    cffi
    xpybutil
    marshmallow
    pyyaml
  ];

  # Tests require access to a X session
  doCheck = false;

  pythonImportsCheck = [ "flashfocus" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
