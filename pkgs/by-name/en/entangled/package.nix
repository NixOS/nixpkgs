{
  python3Packages,
  lib,
  pkgs,
  fetchFromGitHub,
}:
let
  argh_0_30_5 = python3Packages.argh.overridePythonAttrs (old: rec {
    version = "0.30.5";
    src = python3Packages.fetchPypi {
      pname = "argh";
      inherit version;
      hash = "sha256-s339YXoJ0ZpKe8rtDgYLKIvHrI39wPrPiGpJol/zNyg=";
    };
  });
  tomlkit_0_12_5 = python3Packages.tomlkit.overridePythonAttrs (old: rec {
    version = "0.12.5";
    src = python3Packages.fetchPypi {
      pname = "tomlkit";
      inherit version;
      hash = "sha256-7vNPujmDTU1rc8m6fz5NHEF6Tlb4mn6W4JDdDSS4+zw=";
    };
  });
in
python3Packages.buildPythonApplication rec {
  pname = "entangled";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "entangled.py";
    rev = "v${version}";
    sha256 = "sha256-QiRN0cvu6ru5EZLot+p/RRi8okRTmbEjh7sAw1FHUsI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace 'watchdog = "^3.0.0"' 'watchdog = "^4.0.0"'
  '';

  pyproject = true;

  nativeBuildInputs = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    rich
    rich-argparse
    argh_0_30_5
    pkgs.brei
    filelock
    mawk
    pyyaml
    watchdog
    pexpect
    tomlkit_0_12_5
    pkgs.copier
  ];

  meta = {
    description = "Literate programming tool using markdown";
    homepage = "https://entangled.github.io";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = python3Packages.python.meta.platforms;
    license = lib.licenses.asl20;
    mainProgram = "entangled";
  };
}
