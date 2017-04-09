{ stdenv, pythonPackages, fetchFromGitHub,
}:

with pythonPackages; buildPythonApplication rec {
  version = "2.9";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "0ylq0j5w8jvzys4bj9m08bfr1sgf8h2b4fiax6hs6lcwn2882jbr";
  };

  propagatedBuildInputs = [
    cryptography
    beautifulsoup4
    requests2
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

