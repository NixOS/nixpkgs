{
  lib,
  python3Packages,
  _7zz,
  fetchFromGitHub,
  versionCheckHook,
  runCommand,
}:

let
  # gamma-launcher looks for the "7z", not "7zz"
  _7z = runCommand "7z" { } ''
    mkdir -p $out/bin
    ln -s ${_7zz}/bin/7zz $out/bin/7z
  '';
in
python3Packages.buildPythonApplication rec {
  pname = "gamma-launcher";
  version = "2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    tag = "v${version}";
    hash = "sha256-QegptRWMUKpkzsHBdT6KlyyWpmrIuvcyCRvWT9Te3DQ=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    beautifulsoup4
    cloudscraper
    gitpython
    platformdirs
    py7zr
    python-unrar
    requests
    tenacity
    tqdm
  ];

  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postFixup = ''
    wrapProgram $out/bin/gamma-launcher \
    --prefix PATH : "${
      lib.makeBinPath [
        _7z
      ]
    }"
  '';

  meta = {
    description = "Python cli to download S.T.A.L.K.E.R. GAMMA";
    changelog = "https://github.com/Mord3rca/gamma-launcher/releases/tag/v${version}";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    mainProgram = "gamma-launcher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      DrymarchonShaun
      bbigras
    ];
    platforms = lib.platforms.linux;
  };
}
