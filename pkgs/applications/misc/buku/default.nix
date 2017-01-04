{ stdenv, pythonPackages, fetchFromGitHub,
}:

with pythonPackages; buildPythonApplication rec {
  version = "2.7";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "1hb5283xaz1ll3iv5542i6f9qshrdgg33dg7gvghz0fwdh8i0jbk";
  };

  buildInputs = [
    cryptography
    beautifulsoup4
  ];
  propagatedBuildInputs = [ beautifulsoup4 ];

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
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

