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
  setDefaultServerPath ? true,
}:

let
  pname = "rust-analyzer";
  publisher = "rust-lang";

  # Use the plugin version as in vscode marketplace, updated by update script.
  inherit (vsix) version;

  releaseTag = "2025-08-25";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    tag = releaseTag;
    hash = "sha256-apbJj2tsJkL2l+7Or9tJm1Mt5QPB6w/zIyDkCx8pfvk=";
  };

  vsix = buildNpmPackage {
    inherit pname releaseTag;
    version = lib.trim (lib.readFile ./version.txt);
    src = "${src}/editors/code";
    npmDepsHash = "sha256-fV4Z3jj+v56A7wbIEYhVAPVuAMqMds5xSe3OetWAsbw=";
    buildInputs = [
      pkgsBuildBuild.libsecret
    ];
    nativeBuildInputs = [
      jq
      moreutils
      esbuild
      # Required by `keytar`, which is a dependency of `vsce`.
      pkg-config
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
    jq '(.contributes.configuration[] | select(.title == "Server") | .properties."rust-analyzer.server.path".default) = $s' \
      --arg s "${rust-analyzer}/bin/rust-analyzer" \
      package.json | sponge package.json

    # Ensure that the previous modification worked, by searching for the binary path
    grep -Fq ${rust-analyzer}/bin/rust-analyzer package.json || {
      echo "Modifying 'rust-analyzer.server.path' in 'package.json' failed."
      exit 1
    }
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
