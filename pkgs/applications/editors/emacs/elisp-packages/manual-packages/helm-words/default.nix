{ lib
, trivialBuild
, fetchFromGitHub
, dictionary
, emacs
, helm
}:

trivialBuild rec {
  pname = "helm-words";
  version = "0.pre+unstable=2019-03-12";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = pname;
    rev = "e6387ece1940a06695b9d910de3d90252efb8d29";
    hash = "sha256-rh8YKDLZZCUE6JnnRnFyDDyUjK+35+M2dkawR/+qwNM=";
  };

  packageRequires = [ helm dictionary ];

  meta = with lib; {
    homepage = "https://github.com/emacsmirror/helm-words";
    description = "Helm extension for looking up words in dictionaries and thesauri";
    license = licenses.gpl3Plus;
    inherit (emacs.meta) platforms;
  };
}
