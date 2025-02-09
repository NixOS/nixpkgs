{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  pkg-config,
  fdk_aac,
}:

stdenv.mkDerivation rec {
  pname = "fdkaac";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "nu774";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nVVeYk7t4+n/BsOKs744stsvgJd+zNnbASk3bAgFTpk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ fdk_aac ];

  doCheck = true;

  meta = with lib; {
    description = "Command line encoder frontend for libfdk-aac encoder";
    mainProgram = "fdkaac";
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
