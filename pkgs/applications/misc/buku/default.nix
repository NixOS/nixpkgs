{ stdenv, pythonPackages, fetchFromGitHub,
}:

with pythonPackages; buildPythonApplication rec {
  version = "2.5";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "0m6km37zylinsblwm2p8pm760xlsf9m82xyws3762xs8zxbnfmsd";
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

