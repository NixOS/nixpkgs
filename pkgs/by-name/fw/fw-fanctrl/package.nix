{
  lib,
  python3Packages,
  python3,
  fw-ectool,
  fetchFromGitHub,
}:

let
  setuptools_75_8_0 = python3Packages.setuptools.overrideAttrs (old: rec {
    version = "75.8.0";
    src = fetchFromGitHub {
      owner = "pypa";
      repo = "setuptools";
      rev = "v${version}";
      hash = "sha256-dSzsj0lnsc1Y+D/N0cnAPbS/ZYb+qC41b/KfPmL1zI4=";
    };
    patches = [ ];
  });
in
python3Packages.buildPythonPackage rec {
  pname = "fw-fanctrl";
  version = "0-unstable-2025-03-09";

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = "fw-fanctrl";
    hash = "sha256-c+/wEMhWZknEad6Gae6ZYjz2DtE5kkp/rnIOXb8TYeA=";
    rev = "main";
  };

  outputs = [ "out" ];

  format = "pyproject";

  nativeBuildInputs = [
    python3
  ];

  propagatedBuildInputs = with python3Packages; [
    fw-ectool
    setuptools_75_8_0
    jsonschema
  ];

  postInstall = ''
    mkdir -p $out/share/fw-fanctrl
    cp $src/src/fw_fanctrl/_resources/config.json $out/share/fw-fanctrl/config.json
  '';

  doCheck = false;

  meta = with lib; {
    mainProgram = "fw-fanctrl";
    homepage = "https://github.com/TamtamHero/fw-fanctrl";
    description = "A simple systemd service to better control Framework Laptop's fan(s)";
    platforms = lib.platforms.linux;
    license = licenses.bsd3;
    maintainers = [ lib.maintainers.Svenum ];
  };
}
