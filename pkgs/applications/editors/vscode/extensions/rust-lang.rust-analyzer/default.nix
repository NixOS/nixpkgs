{
  lib,
  fetchFromGitHub,
  vscode-utils,
  jq,
  rust-analyzer,
  nodePackages,
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

  build-deps =
    nodePackages."rust-analyzer-build-deps-../../applications/editors/vscode/extensions/rust-lang.rust-analyzer/build-deps";
  # FIXME: Making a new derivation to link `node_modules` and run `npm run package`
  # will cause a build failure.
  vsix = build-deps.override {
    src = "${src}/editors/code";
    outputs = [
      "vsix"
      "out"
    ];

    inherit releaseTag;

    nativeBuildInputs =
      [
        jq
        moreutils
        esbuild
        # Required by `keytar`, which is a dependency of `vsce`.
        pkg-config
        libsecret
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.AppKit
        darwin.apple_sdk.frameworks.Security
      ];

    # Follows https://github.com/rust-lang/rust-analyzer/blob/41949748a6123fd6061eb984a47f4fe780525e63/xtask/src/dist.rs#L39-L65
    postRebuild = ''
      jq '
        .version = $ENV.version |
        .releaseTag = $ENV.releaseTag |
        .enableProposedApi = false |
        walk(del(.["$generated-start"]?) | del(.["$generated-end"]?))
      ' package.json | sponge package.json

      mkdir -p $vsix
      npx vsce package -o $vsix/${pname}.zip
    '';
  };
in
vscode-utils.buildVscodeExtension {
  inherit version vsix;
  name = "${pname}-${version}";
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
