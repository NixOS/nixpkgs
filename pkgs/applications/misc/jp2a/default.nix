{ stdenv, fetchFromGitHub, libjpeg, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.0.7";
  name = "jp2a-${version}";

  src = fetchFromGitHub {
    owner = "cslarsen";
    repo = "jp2a";
    rev = "v${version}";
    sha256 = "12a1z9ba2j16y67f41y8ax5sgv1wdjd71pg7circdxkj263n78ql";
  };

  makeFlags = "PREFIX=$(out)";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libjpeg ];

  meta = with stdenv.lib; {
    homepage = https://csl.name/jp2a/;
    description = "A small utility that converts JPG images to ASCII";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
