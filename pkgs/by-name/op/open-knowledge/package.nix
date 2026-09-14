{
  lib,
  buildNpmPackage,
  cacert,
  fetchzip,
  git,
  jq,
  makeWrapper,
  nodejs_24,
  testers,
}:

buildNpmPackage (finalAttrs: {
  pname = "open-knowledge";
  version = "0.67.0";

  __structuredAttrs = true;

  nodejs = nodejs_24;

  src = fetchzip {
    url = "https://registry.npmjs.org/@inkeep/open-knowledge/-/open-knowledge-${finalAttrs.version}.tgz";
    hash = "sha256-Pbrsp2kt4eLteS4/1mcC2sxgy+h7vArVy2mFYCnDVw8=";
  };

  postPatch = ''
    ${lib.getExe jq} 'del(.devDependencies)' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-YQYRRce5ew31WBQcrQlVNVy//Y6zyNYJGnRhFp9Grnc=";
  npmInstallFlags = [ "--omit=dev" ];

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    for program in open-knowledge ok; do
      wrapProgram "$out/bin/$program" \
        --prefix PATH : ${lib.makeBinPath [ git ]} \
        --set-default SSL_CERT_DIR "${cacert}/etc/ssl/certs" \
        --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
    done
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "open-knowledge --version";
    };
  };

  meta = {
    description = "Local-first, agent-friendly Markdown knowledge base with a CLI and web editor";
    homepage = "https://openknowledge.ai";
    changelog = "https://github.com/inkeep/open-knowledge/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://www.npmjs.com/package/@inkeep/open-knowledge";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.alexeyabel ];
    mainProgram = "open-knowledge";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
