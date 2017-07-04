{ stdenv, pythonPackages, fetchFromGitHub,
}:

with pythonPackages; buildPythonApplication rec {
  version = "3.0";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "1a33x3197vi5s8rq5fvhy021jdlsc8ww8zc4kysss6r9mvdlk7ax";
  };

  propagatedBuildInputs = [
    cryptography
    beautifulsoup4
    requests
    urllib3
  ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    make install PREFIX=$out
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Private cmdline bookmark manager";
    homepage = https://github.com/jarun/Buku;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matthiasbeyer infinisil ];
  };
}

