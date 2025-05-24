{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  pnpm,
  vsce,
  vscode-utils,
  jq,
  moreutils,
  cargo-appraiser,
  setDefaultServerPath ? true,
}:

let
  pname = "cargo-appraiser";
  publisher = "washan";
  owner = "washanhanzi";
  version = "0.2.4";
  releaseTag = "v${version}";
  extId = "${publisher}.${pname}";

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    tag = releaseTag;
    hash = "sha256-5n/HN9vrEqQcvTa19KhoF8EvS7HhO9Q3smMUcauI+n4=";
  };

  extSubDir = "editor/code";

  vsix = stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
      vsce
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit pname version src;
      sourceRoot = "${src.name}/${extSubDir}";
      hash = "sha256-Uw0CQv/qiGEId3gAU+Fpmhb68h8zkYTKRk4XzgtRJ3w=";
    };

    pnpmRoot = extSubDir;

    buildPhase = ''
      runHook preBuild

      pushd ${extSubDir}

      pnpm run build

      popd

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      mv ${extSubDir}/*.vsix $out/${pname}.zip

      runHook postInstall
    '';
  };

in
vscode-utils.buildVscodeExtension {
  inherit version vsix pname;
  src = "${vsix}/${pname}.zip";
  vscodeExtUniqueId = extId;
  vscodeExtPublisher = publisher;
  vscodeExtName = pname;

  nativeBuildInputs = lib.optional setDefaultServerPath [
    jq
    moreutils
  ];
  preInstall = lib.optionalString setDefaultServerPath ''
    jq '(.contributes.configuration[] | select(.title == "cargo-appraiser") | .properties."cargo-appraiser.serverPath".default) = $s' \
      --arg s "${lib.getExe cargo-appraiser}" \
      package.json | sponge package.json
  '';

  meta = {
    description = "VS Code extension that integrates cargo-appraiser, a LSP server for Cargo.toml files, into VS Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=${extId}";
    homepage = "https://github.com/${owner}/${pname}";
    changelog = "https://github.com/${owner}/${pname}/releases/tag/${releaseTag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
  };
}
