{
  lib,
  fetchFromGitHub,
  ocaml-ng,
}:

ocaml-ng.ocamlPackages_4_14.buildDunePackage rec {
  pname = "orpie";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "pelzlpj";
    repo = "orpie";
    tag = "release-${version}";
    sha256 = "sha256-LwhH2BO4p8Y8CB2pNkl2heIR7yh42erdTcDsxgy1ouc=";
  };

  patches = [ ./prefix.patch ];

  preConfigure = ''
    substituteInPlace src/orpie/install.ml.in --replace '@prefix@' $out
  '';

  nativeBuildInputs = [ ocaml-ng.ocamlPackages_4_14.camlp5 ];
  buildInputs = with ocaml-ng.ocamlPackages_4_14; [
    curses
    num
    gsl

  ];

  meta = {
    inherit (src.meta) homepage;
    description = "Curses-based RPN calculator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
