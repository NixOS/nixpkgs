{ stdenv
, fetchurl
, lib
, unzip
,
}:

stdenv.mkDerivation rec {
  pname = "qwerty-fr";
  version = "0.7.3";

  src = fetchurl {
    url = "https://github.com/qwerty-fr/qwerty-fr/releases/download/v${version}/qwerty-fr_${version}_linux.zip";
    sha256 = "0csxzs2gk8l4y5ii1pgad8zxr9m9mfrl9nblywymg01qw74gpvnm";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = "unzip $src";

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';

  meta = with lib; {
    description = "Qwerty keyboard layout with French accents";
    homepage = "https://github.com/qwerty-fr/qwerty-fr";
    license = licenses.mit;
    maintainers = with maintainers; [ potb ];
  };
}
