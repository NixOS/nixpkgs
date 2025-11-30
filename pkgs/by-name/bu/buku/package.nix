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
buildPythonApplication rec {
  version = "5.0";
  pname = "buku";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    tag = "v${version}";
    sha256 = "sha256-b3j3WLMXl4sXZpIObC+F7RRpo07cwJpAK7lQ7+yIzro=";
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

  preCheck = ''
    # Disables a test which requires internet
    substituteInPlace tests/test_bukuDb.py \
      --replace "@pytest.mark.slowtest" "@unittest.skip('skipping')" \
      --replace "self.assertEqual(shorturl, \"http://tny.im/yt\")" "" \
      --replace "self.assertEqual(url, \"https://www.google.com\")" ""
    substituteInPlace setup.py \
      --replace mypy-extensions==0.4.1 mypy-extensions>=0.4.1
  ''
  + lib.optionalString (!withServer) ''
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

  meta = with lib; {
    description = "Private cmdline bookmark manager";
    mainProgram = "buku";
    homepage = "https://github.com/jarun/Buku";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
