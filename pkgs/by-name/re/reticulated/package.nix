{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "reticulated";
  version = "1.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "RFnexus";
    repo = "reticulated";
    tag = "v${finalAttrs.version}";
    hash = "sha256-02vdSKAEb59VucoDe5M+uSiNdyMybfQnhCr+LzGyNT0=";
  };

  postPatch = ''
    substituteInPlace sim/config.py \
      --replace-fail 'os.path.join(BASE_DIR, "web")' '"${placeholder "out"}/share/web"'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    fastapi
    lxmf
    rns
    uvicorn
    websockets
  ];

  postInstall = ''
    mkdir -p "$out/share"
    cp -r web "$out/share/"
  '';

  postFixup = ''
    wrapProgram $out/bin/reticulated \
      --set PYTHONPATH $PYTHONPATH \
      --set SIM_DATA_DIR "/tmp"
  '';

  pythonImportsCheck = [ "sim" ];

  # No --version flag and no Python tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/RFnexus/reticulated/releases/tag/${finalAttrs.src.tag}";
    description = "Reticulum Network Stack Simulator";
    homepage = "https://github.com/RFnexus/reticulated";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "reticulated";
    platforms = lib.platforms.all;
  };
})
