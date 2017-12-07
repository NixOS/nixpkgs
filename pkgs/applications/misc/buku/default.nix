{ stdenv, pythonPackages, fetchFromGitHub }:

with pythonPackages; buildPythonApplication rec {
  version = "3.0"; # When updating to 3.1, make sure to remove the marked line in preCheck
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "1a33x3197vi5s8rq5fvhy021jdlsc8ww8zc4kysss6r9mvdlk7ax";
  };

  nativeBuildInputs = [
    pytestcov
    pytest-catchlog
    hypothesis
    pytest
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

    ### Remove this for 3.1 ###
    # See https://github.com/jarun/Buku/pull/167 (merged)
    substituteInPlace setup.py \
      --replace "hypothesis==3.7.0" "hypothesis>=3.7.0"

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

