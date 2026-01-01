{
  lib,
  python3Packages,
<<<<<<< HEAD
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
=======
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "gamma-launcher";
  version = "2.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-QegptRWMUKpkzsHBdT6KlyyWpmrIuvcyCRvWT9Te3DQ=";
=======
    hash = "sha256-qzjfgDFimEL6vtsJBubY6fHsokilDB248WwHJt3F7fI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  postFixup = ''
    wrapProgram $out/bin/gamma-launcher \
    --prefix PATH : "${
      lib.makeBinPath [
        _7z
      ]
    }"
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Python cli to download S.T.A.L.K.E.R. GAMMA";
    changelog = "https://github.com/Mord3rca/gamma-launcher/releases/tag/v${version}";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    mainProgram = "gamma-launcher";
    license = lib.licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      DrymarchonShaun
      bbigras
    ];
=======
    maintainers = with lib.maintainers; [ DrymarchonShaun ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
  };
}
