{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  npmHooks,
  pkg-config,
  libsecret,
  cctools,
  clang_20,
  vscode-utils,
}:

let
  vsix = stdenv.mkDerivation (finalAttrs: {
    name = "vscode-js-debug-${finalAttrs.version}.zip";
    pname = "vscode-js-debug-vsix";
    version = "1.105.0";

    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-js-debug";
      tag = "v${finalAttrs.version}";
      hash = "sha256-dYEINhJGrJFEq5422BEp3ups6vK0lpVW34GaYPMdfXk=";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      hash = "sha256-bBy0u6NaOAkX6vRJrRYYWUxCG6HM3h0PrzN6tZj5pVY=";
    };
    makeCacheWritable = true;

    nativeBuildInputs = [
      nodejs
      nodejs.python
      npmHooks.npmConfigHook
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
      pkg-config
      libsecret
    ]
    ++ lib.optionals stdenv.isDarwin [
      cctools.libtool
      clang_20 # clang_21 breaks @vscode/vsce's optional dependency keytar
    ];

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "playwright install chromium --with-deps --only-shell" "echo playwright install chromium --with-deps --only-shell"
    '';

    buildPhase = ''
      runHook preBuild
      node --run compile -- package:hoist
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp ./js-debug.vsix $out
      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "vscode-js-debug";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "ms-vscode";
  vscodeExtName = "js-debug";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  meta = {
    description = "An extension for debugging Node.js programs and Chrome";
    homepage = "https://github.com/microsoft/vscode-js-debug";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.js-debug";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
