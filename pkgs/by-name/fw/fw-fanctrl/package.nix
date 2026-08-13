{
  lib,
  python3Packages,
  fw-ectool,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "fw-fanctrl";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = "fw-fanctrl";
    tag = "v${version}";
    hash = "sha256-lwuBbyJnWUAXkKemhsdx73fAzO2QX2n81az074hGkzI=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.jsonschema ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ fw-ectool ]}" ];

  postInstall = ''
    mkdir -p $out/share/fw-fanctrl
    install -m 644 $src/src/fw_fanctrl/_resources/config.json $out/share/fw-fanctrl/config.json
    install -m 755 $src/services/system-sleep/fw-fanctrl-suspend $out/share/fw-fanctrl/fw-fanctrl-suspend
    patchShebangs --build $out/share/fw-fanctrl/fw-fanctrl-suspend
    substituteInPlace $out/share/fw-fanctrl/fw-fanctrl-suspend \
      --replace-fail '"%PYTHON_SCRIPT_INSTALLATION_PATH%"' $out/bin/fw-fanctrl
  '';

  meta = {
    mainProgram = "fw-fanctrl";
    homepage = "https://github.com/TamtamHero/fw-fanctrl";
    description = "Simple systemd service to better control Framework Laptop's fan(s)";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.Svenum ];
  };
}
