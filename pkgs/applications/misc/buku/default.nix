{ stdenv, pythonPackages, fetchFromGitHub,
  encryptionSupport ? false
}:

pythonPackages.buildPythonApplication rec {
  version = "1.9";
  name = "buku-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    rev = "e99844876d0d871df80770b1bd76c161276116eb";
    sha256 = "1qwkff61gdjd6w337a5ipfiybzqdwkxdyfa1l4zzm9dj7lsklgq2";
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

