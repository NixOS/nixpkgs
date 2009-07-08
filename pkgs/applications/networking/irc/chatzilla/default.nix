{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.85";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.85-xr.zip;
    sha256 = "0jd7mq05715vad82sl4ycr7ga587k53dijxz371y3zwpf8479hqx";
  };

  buildInputs = [unzip];

  buildCommand = ''
    ensureDir $out
    unzip $src -d $out
  '';

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
