{ stdenv, autoreconfHook, fetchFromGitHub, fdk_aac }:

stdenv.mkDerivation rec {
  pname = "fdkaac";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nu774";
    repo = pname;
    rev = version;
    sha256 = "16iwqmwagnb929byz8kj79pmmr0anbyv26drbavhppmxhk7rrpgh";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ fdk_aac ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Command line encoder frontend for libfdk-aac encder";
    longDescription = ''
      fdkaac reads linear PCM audio in either WAV, raw PCM, or CAF format,
      and encodes it into either M4A / AAC file.
    '';
    homepage = "https://github.com/nu774/fdkaac";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = [ maintainers.lunik1 ];
  };
}
