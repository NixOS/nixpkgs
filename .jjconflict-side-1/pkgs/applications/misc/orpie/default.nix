{ lib, fetchFromGitHub, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "orpie";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "pelzlpj";
    repo = pname;
    rev = "release-${version}";
    sha256 = "1rx2nl6cdv609pfymnbq53pi3ql5fr4kda8x10ycd9xq2gc4f21g";
  };

  patches = [ ./prefix.patch ];

  preConfigure = ''
    substituteInPlace src/orpie/install.ml.in --replace '@prefix@' $out
  '';

  nativeBuildInputs = [ ocamlPackages.camlp5 ];
  buildInputs = with ocamlPackages; [ curses num gsl ];

  meta = {
    inherit (src.meta) homepage;
    description = "Curses-based RPN calculator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ obadz ];
  };
}
