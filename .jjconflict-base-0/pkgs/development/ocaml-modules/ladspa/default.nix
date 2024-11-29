{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, ladspaH }:

buildDunePackage rec {
  pname = "ladspa";
  version = "0.2.2";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ladspa";
    rev = "v${version}";
    sha256 = "1y83infjaz9apzyvaaqw331zqdysmn3bpidfab061v3bczv4jzbz";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ladspaH ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-alsa";
    description = "Bindings for the LADSPA API which provides audio effects";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
