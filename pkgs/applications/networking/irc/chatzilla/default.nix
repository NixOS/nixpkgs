{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.83";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.83-xr.zip;
    sha256 = "0dzk0k9gmzy7sqbiszakd69pjr4h6pfdsb3s6zbx4gc46z4n3shx";
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
