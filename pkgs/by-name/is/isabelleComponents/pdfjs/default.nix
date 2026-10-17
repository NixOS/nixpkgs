{
  stdenvNoCC,
  npmHooks,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdfjs";
  version = "5.4.394";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "pdf.js";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nIaRNF5a0Cy3wBbDHSdQEexoBx9Ssdb3XVXSPt0NDM0=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-QUn3gGZZNqJTopBX25bSTRir+IiRKYG42jJKtKFgDVw=";
  };

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    npx gulp generic

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/pdfjs
    cp -r build/generic/{build,web} $out/share/pdfjs

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "pdfjs-settings";
    text = ''
      ISABELLE_PDFJS_HOME="${finalAttrs.finalPackage}/share/pdfjs"
    '';
    destination = "/etc/settings";
  };
})
