{ lib, stdenv, autoreconfHook, fetchFromGitHub, fdk_aac }:

stdenv.mkDerivation rec {
  pname = "fdkaac";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "nu774";
    repo = pname;
    rev = "v${version}";
    sha256 = "tHhICq/FzbkvWkDdNzGqGoo7nIDb+DJXmkFwtPIA89c=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ fdk_aac ];

  doCheck = true;

  meta = with lib; {
    description = "Command line encoder frontend for libfdk-aac encoder";
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
