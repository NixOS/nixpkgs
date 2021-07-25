{ lib, python3, fetchFromGitHub }:

let
  python3' = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ebbb777cbf9312359b897bf81ba00dae0f5cb69fba2a18265dcc18a6f5ef7519";
        };
      });
      sqlalchemy-utils = super.sqlalchemy-utils.overridePythonAttrs (oldAttrs: rec {
        version = "0.36.6";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0srs5w486wp5zydjs70igi5ypgxhm6h73grb85jz03fqpqaanzvs";
        };
      });
    };
  };
in
with python3'.pkgs; buildPythonApplication rec {
  version = "4.6";
  pname = "buku";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "sha256-hr9qiP7SbloigDcs+6KVWu0SOlggMaBr7CCfY8zoJG0=";
  };

  checkInputs = [
    pytest-cov
    hypothesis
    pytest
    pytest-vcr
    pylint
    flake8
    pyyaml
    mypy-extensions
  ];

  propagatedBuildInputs = [
    cryptography
    beautifulsoup4
    requests
    urllib3
    flask
    flask-admin
    flask-api
    flask-bootstrap
    flask-paginate
    flask-reverse-proxy-fix
    flask_wtf
    arrow
    werkzeug
    click
    html5lib
    vcrpy
    toml
  ];

  postPatch = ''
    # Jailbreak problematic dependencies
    sed -i \
      -e "s,'PyYAML.*','PyYAML',g" \
      setup.py
  '';

  preCheck = ''
    # Fixes two tests for wrong encoding
    export PYTHONIOENCODING=utf-8

    # Disables a test which requires internet
    substituteInPlace tests/test_bukuDb.py \
      --replace "@pytest.mark.slowtest" "@unittest.skip('skipping')" \
      --replace "self.assertEqual(shorturl, \"http://tny.im/yt\")" "" \
      --replace "self.assertEqual(url, \"https://www.google.com\")" ""
    substituteInPlace setup.py \
      --replace mypy-extensions==0.4.1 mypy-extensions>=0.4.1
  '';

  postInstall = ''
    make install PREFIX=$out

    mkdir -p $out/share/zsh/site-functions $out/share/bash-completion/completions $out/share/fish/vendor_completions.d
    cp auto-completion/zsh/* $out/share/zsh/site-functions
    cp auto-completion/bash/* $out/share/bash-completion/completions
    cp auto-completion/fish/* $out/share/fish/vendor_completions.d
  '';

  meta = with lib; {
    description = "Private cmdline bookmark manager";
    homepage = "https://github.com/jarun/Buku";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer infinisil ma27 ];
  };
}

