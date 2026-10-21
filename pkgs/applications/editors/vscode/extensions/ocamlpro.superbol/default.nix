{
  lib,
  stdenv,
  fetchNpmDeps,
  ocamlPackages,
  vscode-utils,
  npmHooks,
  nodejs-slim,
  llvmPackages_20,
  dune_3,
  pkg-config,
  libsecret,
  vsce,
}:

let
  vsixStdenv = if stdenv.cc.isClang then llvmPackages_20.stdenv else stdenv;
  vsix = vsixStdenv.mkDerivation (finalAttrs: {
    name = "superbol-studio-oss-${finalAttrs.version}.vsix";
    pname = "superbol-studio-oss-vsix";

    strictDeps = true;
    __structuredAttrs = true;

    inherit (ocamlPackages.superbol-studio-oss) version src patches;

    prePatch = ''
      rm -rf import/gnucobol*
    '';

    # [ERROR] Big integer literals are not available in the configured target environment ("es2015")
    postPatch = ''
      substituteInPlace Makefile.vsix-rules \
        --replace-fail '--target=es6' '--target=es2020'
    '';

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      hash = "sha256-7wu+iPsVUz9qVFZonF7pGrrwSPyGdFWOonUttWe53lM=";
    };

    nativeBuildInputs = [
      nodejs-slim
      nodejs-slim.npm
      nodejs-slim.python
      npmHooks.npmConfigHook
      ocamlPackages.ocaml
      ocamlPackages.gen_js_api
      ocamlPackages.js_of_ocaml
      dune_3
      pkg-config
      vsce
    ];

    buildInputs = [
      ocamlPackages.superbol-studio-oss
      libsecret
    ];

    buildPhase = ''
      runHook preBuild

      # Taken from the steps of `make compile` in the upstream repo
      make build-release DUNE=dune LINKING_MODE=static
      ln -s ${lib.getExe ocamlPackages.superbol-studio-oss} _dist
      vsce package --no-git-tag-version	--no-update-package-json \
        --out package.vsix "$version"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -m644 package.vsix $out
      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "superbol-studio-oss";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "OCamlPro";
  vscodeExtName = "SuperBOL";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
  };

  meta = {
    description = "Visual Studio Code extension for COBOL";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=OCamlPro.SuperBOL";
    homepage = "https://superbol.eu/en";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
    teams = [ lib.teams.ngi ];
  };
})
