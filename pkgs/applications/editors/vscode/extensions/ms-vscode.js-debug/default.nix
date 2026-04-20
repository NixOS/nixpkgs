{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  nodejs-slim,
  npmHooks,
  pkg-config,
  libsecret,
  cctools,
  clang_20,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenv.mkDerivation (finalAttrs: {
    name = "vscode-js-debug-${finalAttrs.version}.vsix";
    pname = "vscode-js-debug-vsix";
    version = "1.112.0";

    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode-js-debug";
      tag = "v${finalAttrs.version}";
      hash = "sha256-pgDrGbx4E6r5lkdY49RyEe04YZYVXbjKAB+pY5w5w7U=";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      hash = "sha256-e+23PCPPQeHKxIT0nFEPumg2TvtNtpzil3XS5njHR9g=";
    };
    makeCacheWritable = true;

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      libsecret
    ];
    nativeBuildInputs = [
      nodejs
      nodejs-slim.python
      npmHooks.npmConfigHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      cctools.libtool
      clang_20 # clang_21 breaks @vscode/vsce's optional dependency keytar
    ];

    strictDeps = true;

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

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.ms-vscode.js-debug.vsix";
    };
  };

  meta = {
    description = "An extension for debugging Node.js programs and Chrome";
    homepage = "https://github.com/microsoft/vscode-js-debug";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.js-debug";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
