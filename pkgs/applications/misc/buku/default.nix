{ stdenv, python3, fetchFromGitHub, fetchpatch }:

with python3.pkgs; buildPythonApplication rec {
  version = "3.7";
  pname = "buku";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "0qc6xkrhf2phaj9fhym19blr4rr2vllvnyljjz909xr4vsynvb41";
  };

  patches = fetchpatch {
    url = https://github.com/jarun/Buku/commit/495d6eac4d9371e8ce6d3f601e2bb9e5e74962b4.patch;
    sha256 = "0py4l5qcgdzqr0iqmcc8ddld1bspk8iwypz4dcr88y70j86588gk";
  };

  checkInputs = [
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
      --replace "@pytest.mark.slowtest" "@unittest.skip('skipping')" \
      --replace "self.assertEqual(shorturl, 'http://tny.im/yt')" "" \
      --replace "self.assertEqual(url, 'https://www.google.com')" ""
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
    maintainers = with maintainers; [ infinisil ];
  };
}

