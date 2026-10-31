{
  buildNpmPackage,
  fetchFromGitHub,
  writeTextFile,
}:

buildNpmPackage (finalAttrs: {
  pname = "prismjs";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "PrismJS";
    repo = "prism";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/UcqbqnO84SnC51eVLBZyUJfPWfNliKoHwGwJoSVS24=";
  };

  npmDepsHash = "sha256-CYTWO6ZxSRq0LNTi12/UyI1opdu6npg05eDE2mAOMy8=";

  passthru.settings = writeTextFile {
    name = "prismjs-settings";
    text = ''
      ISABELLE_PRISMJS_HOME="${finalAttrs.finalPackage}/lib/node_modules/prismjs"
    '';
    destination = "/etc/settings";
  };
})
