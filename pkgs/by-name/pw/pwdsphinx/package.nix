{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pwdsphinx";
  version = "2.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stef";
    repo = "pwdsphinx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-COSfA5QqIGWEnahmo5klFECK7XjyabGs1nG9vyhj/DM=";
  };

  postPatch = ''
    substituteInPlace ./setup.py \
      --replace-fail 'zxcvbn-python' 'zxcvbn'
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    cbor2
    pyequihash
    pyoprf
    pysodium
    qrcodegen
    securestring
    zxcvbn
  ];

  # for man pages
  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postInstall = ''
    mkdir -p $out/share/doc/pwdsphinx/
    cp -r ./configs $out/share/doc/pwdsphinx/
    installManPage man/*.1
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    mkdir -p ~/.config/sphinx
    cp ${finalAttrs.src}/configs/config ~/.config/sphinx/config
    # command fails without key but the command generates the key, so always pass
    $out/bin/sphinx init || true
  '';

  pythonImportsCheck = [ "pwdsphinx" ];

  meta = {
    description = "Native backend for web-extensions for Sphinx-based password storage";
    homepage = "https://www.ctrlc.hu/~stef/blog/posts/sphinx.html";
    downloadPage = "https://github.com/stef/pwdsphinx";
    changelog = "https://github.com/stef/pwdsphinx/releases/tag/v${finalAttrs.version}";
    teams = [ lib.teams.ngi ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "sphinx";
  };
})
