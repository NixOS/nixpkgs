{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.84";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.84-xr.zip;
    sha256 = "0v1xakdgjjwwh0azxbh7y9yi99gcn0d37sfxrdzw78lbag3fh0k8";
  };

  buildInputs = [unzip];

  buildCommand = ''
    ensureDir $out
    unzip $src -d $out

    # Fix overly restrictive version specification.    
    substituteInPlace $out/application.ini --replace 'MaxVersion=1.9' 'MaxVersion=1.9.0.999'
  '';

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
