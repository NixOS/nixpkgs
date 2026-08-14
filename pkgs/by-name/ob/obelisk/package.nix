{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "obelisk";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Lelio-Brun";
    repo = "obelisk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JJ8k9/6awKZH87T9Ut8x/hlshiUI6sy2fZtY6x2dIIk=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [ menhir ];
  buildInputs = with ocamlPackages; [ re ];

  meta = {
    description = "Simple tool which produces pretty-printed output from a Menhir parser file (.mly)";
    mainProgram = "obelisk";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Lelio-Brun/Obelisk";
  };
})
