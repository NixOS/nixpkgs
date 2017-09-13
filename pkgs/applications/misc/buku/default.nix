{ stdenv, python3, fetchFromGitHub }:

with python3.pkgs; buildPythonApplication rec {
  version = "3.3.1";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "1byq8jgv1rb67ygibk0vzgz5ri1il4q4hpg23z5q0ml27fif9hw3";
  };

  nativeBuildInputs = [
    pytestcov
    pytest-catchlog
    hypothesis
    pytest
    pylint
    flake8
  ];

  propagatedBuildInputs = [
    cryptography
    beautifulsoup4
    requests
    urllib3
  ];

  preCheck = ''
    # Fixes two tests for wrong encoding
    export PYTHONIOENCODING=utf-8

    # Disables a test which requires internet
    substituteInPlace tests/test_bukuDb.py \
      --replace "@pytest.mark.slowtest" "@unittest.skip('skipping')"
  '';

  installPhase = ''
    make install PREFIX=$out

    mkdir -p $out/share/zsh/site-functions $out/share/bash-completion/completions $out/share/fish/vendor_completions.d
    cp auto-completion/zsh/* $out/share/zsh/site-functions
    cp auto-completion/bash/* $out/share/bash-completion/completions
    cp auto-completion/fish/* $out/share/fish/vendor_completions.d
  '';

  meta = with stdenv.lib; {
    description = "Private cmdline bookmark manager";
    homepage = https://github.com/jarun/Buku;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matthiasbeyer infinisil ];
  };
}

