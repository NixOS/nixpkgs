{
  lib,
  fetchFromGitHub,
  stdenv,
  npmHooks,
  fetchNpmDeps,
  typescript,
  nodejs,
  vsce,
  zig,
  unzip,
  moreutils,
}:

let
  name = "jjk";
  publisher = "jjk";
  owner = "keanemind";
  version = "0.8.1";
  releaseTag = "v${version}";
  extId = "${publisher}.${name}";

  src = fetchFromGitHub {
    inherit owner;
    repo = name;
    tag = releaseTag;
    hash = "sha256-zB3CflSUNmNfTijl37AXsGww2LuFEONQQA43bfku3f8=";
  };

  fakeeditorPkg = stdenv.mkDerivation {
    pname = "fakeeditor";
    inherit version src;
    nativeBuildInputs = [
      zig.hook
    ];
    sourceRoot = "${src.name}/src/fakeeditor";
    meta.mainProgram = "fakeeditor";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vscode-extension-${publisher}-${name}";
  inherit version src;

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-er2Sy1NSnTSEbFH7w3Kcr3/+vkc8n1ju72n+LtjrR2Y=";
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    typescript
    nodejs
    vsce
    unzip
    moreutils
  ];

  postPatch = ''
    sed 's/&& npm run build-fakeeditor[^"]*//g' package.json | sponge package.json
    substituteInPlace src/repository.ts \
      --replace-fail 'const fakeEditorExecutables' 'const _fakeEditorExecutables' \
      --replace-fail 'fakeEditorExecutables[process.platform]?.[process.arch];' 'null; fakeEditorPath = "${lib.getExe fakeeditorPkg}";'
  '';

  buildPhase = ''
    runHook preBuild

    node esbuild.js --production
    cp -r src/webview dist/
    cp src/config.toml dist/
    mkdir -p dist/codicons
    cp -r node_modules/@vscode/codicons/dist/* dist/codicons/

    vsce package --allow-star-activation --out ./${name}-${version}.vsix

    mkdir -p unpacked
    unzip ./${name}-${version}.vsix 'extension/*' -d ./unpacked

    echo ${fakeeditorPkg}

    runHook postBuild
  '';

  installPrefix = "share/vscode/extensions/${extId}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/$installPrefix
    mv ./unpacked/extension/* $out/$installPrefix

    runHook postInstall
  '';

  passthru = {
    vscodeExtPublisher = publisher;
    vscodeExtName = name;
    vscodeExtUniqueId = extId;
  };

  meta = {
    description = "VS Code Extension for Jujutsu (jj) VCS support";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=${extId}";
    homepage = "https://github.com/${owner}/${name}";
    changelog = "https://github.com/${owner}/${name}/releases/tag/${releaseTag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
  };
})
