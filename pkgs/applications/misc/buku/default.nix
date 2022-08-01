{ lib, python3, fetchFromGitHub, withServer ? false }:

let
  python3' = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs (oldAttrs: rec {
        version = "1.3.24";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-67t3fL+TEjWbiXv4G6ANrg9ctp+6KhgmXcwYpvXvdRk=";
        };
        doCheck = false;
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
  serverRequire = with python3'.pkgs; [
    requests
    flask
    flask-admin
    flask-api
    flask-bootstrap
    flask-paginate
    flask-reverse-proxy-fix
    flask-wtf
    arrow
    werkzeug
    click
    vcrpy
    toml
  ];
in
with python3'.pkgs; buildPythonApplication rec {
  version = "4.7";
  pname = "buku";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "sha256-7piJK1hz9h6EWiU/q5MAS1PSvHFxnW7rZBKxq+wda1c=";
  };

  checkInputs = [
    hypothesis
    pytest
    pytest-vcr
    pyyaml
    mypy-extensions
    click
  ];

  propagatedBuildInputs = [
    cryptography
    beautifulsoup4
    certifi
    urllib3
    html5lib
  ] ++ lib.optionals withServer serverRequire;

  postPatch = ''
    # Jailbreak problematic dependencies
    sed -i \
      -e "s,'PyYAML.*','PyYAML',g" \
      -e "/'pytest-cov/d" \
      -e "/'pylint/d" \
      -e "/'flake8/d" \
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
  '' + lib.optionalString (!withServer) ''
    rm tests/test_{server,views}.py
  '';

  postInstall = ''
    make install PREFIX=$out

    mkdir -p $out/share/zsh/site-functions $out/share/bash-completion/completions $out/share/fish/vendor_completions.d
    cp auto-completion/zsh/* $out/share/zsh/site-functions
    cp auto-completion/bash/* $out/share/bash-completion/completions
    cp auto-completion/fish/* $out/share/fish/vendor_completions.d
  '' + lib.optionalString (!withServer) ''
    rm $out/bin/bukuserver
  '';

  meta = with lib; {
    description = "Private cmdline bookmark manager";
    homepage = "https://github.com/jarun/Buku";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer infinisil ma27 ];
  };
}
