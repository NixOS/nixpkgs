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

  releaseTag = "2025-02-17";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = releaseTag;
    hash = "sha256-i76MMFSkCr4kDwurK8CACwZq7qEgVEgIzkOr2kiuAKk=";
  };

  vsix = buildNpmPackage {
    inherit pname releaseTag;
    version = lib.trim (lib.readFile ./version.txt);
    src = "${src}/editors/code";
    npmDepsHash = "sha256-0frOGphtzO6z8neSEYfjyRYrM6zEO3wId/TACblZkxM=";
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
