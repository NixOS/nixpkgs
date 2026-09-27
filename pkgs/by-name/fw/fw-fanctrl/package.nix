{
  lib,
  python3Packages,
  framework-tool,
  frameworkToolPackage ? framework-tool,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "fw-fanctrl";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = "fw-fanctrl";
    tag = "v${version}";
    hash = "sha256-UFjKzCQ5QBw6t7LZ3d2Nk1G8WcsuuLkZkEkx0Sf6ndw=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.jsonschema ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ frameworkToolPackage ]}" ];

  postInstall = ''
    mkdir -p $out/share/fw-fanctrl
    install -m 644 $src/src/fw_fanctrl/_resources/config.json $out/share/fw-fanctrl/config.json
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
