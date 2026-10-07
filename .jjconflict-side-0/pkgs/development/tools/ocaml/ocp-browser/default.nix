{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  cppo,
  ocp-index,
  cmdliner,
  re,
  lambda-term,
  zed,
}:

buildDunePackage (finalAttrs: {
  pname = "ocp-browser";
  version = "1.4.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-index";
    tag = finalAttrs.version;
    hash = "sha256-B8D3p9Cj67Cb+AH06jg+kJJiaM/ejnsSsQk1yHRmDqU=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [
    cmdliner
    lambda-term
    ocp-index
    re
    zed
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/ocp-index";
    description = "Console browser for the documentation of installed OCaml libraries";
    changelog = "https://github.com/OCamlPro/ocp-index/raw/${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ redianthus ];
    mainProgram = "ocp-browser";
  };
})
