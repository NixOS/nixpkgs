{ stdenv, pythonPackages, fetchFromGitHub,
}:

pythonPackages.buildPythonApplication rec {
  version = "2.4";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "v${version}";
    sha256 = "0rmvlpp1pzzgn1hf87ksigj9kp60gfwkvxymb4wiz7dqa57b1q0n";
  };

  buildInputs = [
    pythonPackages.cryptography
    pythonPackages.beautifulsoup4
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
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

