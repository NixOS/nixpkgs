{ lib, fetchFromGitHub, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "orpie";
  version = "1.6.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "pelzlpj";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1rx2nl6cdv609pfymnbq53pi3ql5fr4kda8x10ycd9xq2gc4f21g";
  };

  preConfigure = ''
    patchShebangs scripts
    substituteInPlace scripts/compute_prefix \
      --replace '"topfind"' \
      '"${ocamlPackages.findlib}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/topfind"'
    export PREFIX=$out
  '';

  buildInputs = with ocamlPackages; [ curses camlp5 num gsl ];

  meta = {
    inherit (src.meta) homepage;
    description = "A Curses-based RPN calculator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
