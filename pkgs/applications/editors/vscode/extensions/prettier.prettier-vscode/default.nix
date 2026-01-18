{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  libsecret,
  nodejs,
  npmHooks,
  pkg-config,
  clang_20,
  vscode-utils,
  nix-update-script,
}:

let
  vsix = stdenv.mkDerivation (finalAttrs: {
    name = "prettier-vscode-${finalAttrs.version}.vsix";
    pname = "prettier-vscode-vsix";
    version = "12.0.7";

    src = fetchFromGitHub {
      owner = "prettier";
      repo = "prettier-vscode";
      tag = "v${finalAttrs.version}";
      hash = "sha256-pbUvgchOEWgBm0D5wdAPMfHouFdHZPEvCChD9JJf4Xk=";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      hash = "sha256-VcJ3mzuspML2z3EzAUi21tavPtI62/Jo3X8swnMXwOs=";
    };

    buildInputs = lib.optionals stdenv.isLinux [
      libsecret
    ];

    nativeBuildInputs = [
      nodejs
      nodejs.python
      npmHooks.npmConfigHook
    ]
    ++ lib.optionals stdenv.isLinux [
      pkg-config
    ]
    ++ lib.optionals stdenv.isDarwin [
      clang_20 # clang_21 breaks @vscode/vsce's optional dependency keytar
    ];

    strictDeps = true;

    env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

    buildPhase = ''
      runHook preBuild

      node --run compile
      npx @vscode/vsce package --out $out

      runHook postBuild
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "prettier-vscode";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "prettier";
  vscodeExtName = "prettier-vscode";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.prettier.prettier-vscode.vsix";
    };
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/Prettier.prettier-vscode/changelog";
    description = "Visual Studio Code extension for Prettier";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=Prettier.prettier-vscode";
    homepage = "https://github.com/prettier/prettier-vscode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})
