{
  lib,
  python3,
  fetchFromGitHub,
  withServer ? false,
}:

let
  serverRequire = with python3.pkgs; [
    requests
    flask
    flask-admin
    flask-api
    flask-bootstrap
    flask-paginate
    flask-wtf
    arrow
    werkzeug
    click
    vcrpy
    toml
  ];
in
with python3.pkgs;
buildPythonApplication (finalAttrs: {
  version = "5.1.1";
  pname = "buku";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-7dxe1GUdBDP/mNfYKkJzKNTgzXLfVQxp4REEkFIh4Bs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-recording
    pyyaml
    mypy-extensions
    click
    pylint
    flake8
    pytest-cov-stub
    pyyaml
  ];

  propagatedBuildInputs = [
    cryptography
    beautifulsoup4
    certifi
    urllib3
    html5lib
  ]
  ++ lib.optionals withServer serverRequire;

  preCheck = lib.optionalString (!withServer) ''
    rm tests/test_{server,views}.py
  '';

  postInstall = ''
    make install PREFIX=$out

    mkdir -p $out/share/zsh/site-functions $out/share/bash-completion/completions $out/share/fish/vendor_completions.d
    cp auto-completion/zsh/* $out/share/zsh/site-functions
    cp auto-completion/bash/* $out/share/bash-completion/completions
    cp auto-completion/fish/* $out/share/fish/vendor_completions.d
  ''
  + lib.optionalString (!withServer) ''
    rm $out/bin/bukuserver
  '';

  meta = {
    description = "Private cmdline bookmark manager";
    mainProgram = "buku";
    homepage = "https://github.com/jarun/Buku";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
