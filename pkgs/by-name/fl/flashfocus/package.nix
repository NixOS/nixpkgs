{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch,
  netcat-openbsd,
  procps,
  bash,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "flashfocus";
  version = "2.4.1";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-O6jRQ6e96b8CuumTD6TGELaz26No7WFZgGSnNSlqzuE=";
  };

  patches = [
    (fetchpatch {
      name = "bump-marshmallow.patch";
      url = "https://github.com/fennerm/flashfocus/commit/0ed8616ad31c5e281be1a890ad9510323fa1b6c7.patch";
      hash = "sha256-A7PwvqPpi4koKD3d6SRHVV753hGd9wIf3/nT49f6qoY=";
    })
  ];

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

  meta = {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin ];
  };
})
