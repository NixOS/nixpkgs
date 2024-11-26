{
  angstrom,
  buildDunePackage,
  fetchurl,
  findlib,
  lib,
  ocaml,
  re,
}:

buildDunePackage rec {
  pname = "uuuu";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/mirage/uuuu/releases/download/v${version}/uuuu-${version}.tbz";
    sha256 = "sha256:19n39yc7spgzpk9i70r0nhkwsb0bfbvbgpf8d863p0a3wgryhzkb";
  };

  postPatch = ''
    substituteInPlace src/dune --replace 'ocaml} ' \
      'ocaml} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib '
  '';

  nativeBuildInputs = [ findlib ];

  buildInputs = [ angstrom ];

  checkInputs = [ re ];
  doCheck = true;

  duneVersion = "3";

  meta = {
    description = "Library to normalize an ISO-8859 input to Unicode code-point";
    homepage = "https://github.com/mirage/uuuu";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "uuuu.generate";
  };
}
