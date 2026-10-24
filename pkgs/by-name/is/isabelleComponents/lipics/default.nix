{
  stdenvNoCC,
  fetchFromGitHub,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "latex-lipics";
  version = "3.1.3";

  outputs = [ "tex" ];

  src = fetchFromGitHub {
    owner = "dagstuhl-publishing";
    repo = "styles";
    tag = "v2021.2.3";
    hash = "sha256-zg5dIpTxXD0Z+VyhOCTK+AZnbqjAnk7ntrm3IL6vIb4=";
  };
  sourceRoot = "${finalAttrs.src.name}/LIPIcs";

  # multiple-outputs.sh fails if $out is not defined
  preHook = ''
    out="''${tex-}"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/tex/latex/lipics
    install -m644 authors/lipics-v2021.cls editors/lipicsmaster-v2021.cls $out/tex/latex/lipics

    runHook postInstall
  '';

  passthru = {
    tlDeps = ps: [ ps.latex ];
    settings = writeTextFile {
      name = "lipics-settings";
      text = ''
        ISABELLE_LIPICS_HOME="${finalAttrs.finalPackage.tex}/tex/latex/lipics"
      '';
      destination = "/etc/settings";
    };
  };
})
