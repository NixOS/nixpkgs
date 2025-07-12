{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  pnpm,
  vsce,
  unzip,
  jq,
  moreutils,
  cargo-appraiser,
  setDefaultServerPath ? true,
}:

let
  name = "cargo-appraiser";
  publisher = "washan";
  owner = "washanhanzi";
  version = "0.2.1";
  releaseTag = "vscode/v${version}";
  extId = "${publisher}.${name}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vscode-extension-${publisher}-${name}";
  inherit version;

  src = fetchFromGitHub {
    inherit owner;
    repo = name;
    tag = releaseTag;
    hash = "sha256-YbrswdLNrd+p4NHLyt1OKfAO270N+Wi3ANiAZHg2zjE=";
  };

  extSubDir = "editor/code";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.extSubDir}";
    hash = "sha256-Uw0CQv/qiGEId3gAU+Fpmhb68h8zkYTKRk4XzgtRJ3w=";
  };

  pnpmRoot = finalAttrs.extSubDir;

  nativeBuildInputs =
    [
      nodejs
      pnpm.configHook
      vsce
      unzip
    ]
    ++ lib.optional setDefaultServerPath [
      jq
      moreutils
    ];

  postPatch = lib.optionalString setDefaultServerPath ''
    pushd ${finalAttrs.extSubDir}

    jq '(.contributes.configuration[] | select(.title == "cargo-appraiser") | .properties."cargo-appraiser.serverPath".default) = $s' \
      --arg s "${lib.getExe cargo-appraiser}" \
      package.json | sponge package.json

    popd
  '';

  buildPhase = ''
    runHook preBuild

    pushd ${finalAttrs.extSubDir}

    pnpm run build

    mkdir -p dist
    unzip ./*.vsix 'extension/*' -d ./dist

    popd

    runHook postBuild
  '';

  installPrefix = "share/vscode/extensions/${extId}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/$installPrefix
    mv ${finalAttrs.extSubDir}/dist/extension/* $out/$installPrefix

    runHook postInstall
  '';

  passthru = {
    vscodeExtPublisher = publisher;
    vscodeExtName = name;
    vscodeExtUniqueId = extId;
  };

  meta = {
    description = "VS Code extension that integrates cargo-appraiser, a LSP server for Cargo.toml files, into VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=${extId}";
    homepage = "https://github.com/${owner}/${name}";
    changelog = "https://github.com/${owner}/${name}/releases/tag/${releaseTag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
  };
})
