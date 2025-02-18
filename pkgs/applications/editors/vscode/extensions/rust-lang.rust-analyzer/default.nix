{
  pkgsBuildBuild,
  lib,
  fetchFromGitHub,
  vscode-utils,
  jq,
  rust-analyzer,
  buildNpmPackage,
  moreutils,
  esbuild,
  pkg-config,
  libsecret,
  stdenv,
  darwin,
  setDefaultServerPath ? true,
}:

let
  pname = "rust-analyzer";
  publisher = "rust-lang";

  # Use the plugin version as in vscode marketplace, updated by update script.
  inherit (vsix) version;

  releaseTag = "2024-07-08";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = releaseTag;
    hash = "sha256-STmaV9Zu74QtkGGrbr9uMhskwagfCjJqOAYapXabiuk=";
  };

  vsix = buildNpmPackage {
    inherit pname releaseTag;
    version = lib.trim (lib.readFile ./version.txt);
    src = "${src}/editors/code";
    npmDepsHash = "sha256-EtkgnNOAKDQP7BDHI667SPu73tYrz1Hq6TmeeObXnf4=";
    buildInputs = [
      pkgsBuildBuild.libsecret
    ];
    nativeBuildInputs =
      [
        jq
        moreutils
        esbuild
        # Required by `keytar`, which is a dependency of `vsce`.
        pkg-config
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        darwin.apple_sdk.frameworks.AppKit
        darwin.apple_sdk.frameworks.Security
      ];

    # Follows https://github.com/rust-lang/rust-analyzer/blob/41949748a6123fd6061eb984a47f4fe780525e63/xtask/src/dist.rs#L39-L65
    installPhase = ''
      jq '
        .version = $ENV.version |
        .releaseTag = $ENV.releaseTag |
        .enableProposedApi = false |
        walk(del(.["$generated-start"]?) | del(.["$generated-end"]?))
      ' package.json | sponge package.json

      mkdir -p $out
      npx vsce package -o $out/${pname}.zip
    '';
  };

in
vscode-utils.buildVscodeExtension {
  inherit version vsix pname;
  src = "${vsix}/${pname}.zip";
  vscodeExtUniqueId = "${publisher}.${pname}";
  vscodeExtPublisher = publisher;
  vscodeExtName = pname;

  nativeBuildInputs = lib.optionals setDefaultServerPath [
    jq
    moreutils
  ];

  preInstall = lib.optionalString setDefaultServerPath ''
    jq '(.contributes.configuration[] | select(.title == "server") | .properties."rust-analyzer.server.path".default) = $s' \
      --arg s "${rust-analyzer}/bin/rust-analyzer" \
      package.json | sponge package.json
  '';

  meta = {
    description = "Alternative rust language server to the RLS";
    homepage = "https://github.com/rust-lang/rust-analyzer";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
