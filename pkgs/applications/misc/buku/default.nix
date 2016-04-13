{ stdenv, pythonPackages, fetchFromGitHub,
  encryptionSupport ? false
}:

pythonPackages.buildPythonApplication rec {
  version = "1.8";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "53d48ee56a3abfb53b94ed25fb620ee759141c96";
    sha256 = "185d3gndw20c3l6f3mf0iq4qapm8g30bl0hn0wsqpp36vl0bpq28";
  };

  buildInputs = stdenv.lib.optional encryptionSupport pythonPackages.pycrypto;

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

