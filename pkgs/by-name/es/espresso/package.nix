{
  lib,
  fetchFromGitHub,
  cmake,
  stdenv,
  nix-update-script,
  asciidoctor,
}:
stdenv.mkDerivation rec {
  pname = "espresso";
  version = "2.5.1";
  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "espresso";
    rev = "v${version}";
    hash = "sha256-dZigbd4md8ffFawpPB/N/TccBQL6sbMKN2VdGu+fhKY=";
  };

  nativeBuildInputs = [
    cmake
    asciidoctor
  ];

  doCheck = true;

  outputs = [
    "out"
    "man"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-valued PLA minimization";
    # from manual
    longDescription = ''
      Espresso takes as input a two-level representation of a
      two-valued (or multiple-valued) Boolean function, and produces a
      minimal equivalent representation.  The algorithms used are new and
      represent an advance in both speed and optimality of solution in
      heuristic Boolean minimization.
    '';
    homepage = "https://github.com/chipsalliance/espresso";
    changelog = "https://github.com/chipsalliance/espresso/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ pineapplehunter ];
    mainProgram = "espresso";
    platforms = lib.platforms.all;

    # The license is not provided in the GitHub repo,
    # so until there's an update on the license, it is marked as unfree.
    # See: https://github.com/chipsalliance/espresso/issues/4
    license = lib.licenses.unfree;
  };
}
