{
  lib,
  stdenv,
  fetchurl,
  vscode-utils,
  jq,
  moreutils,
  openjdk21,
}:

let
  version = "261.13587.0";

  sources = {
    "x86_64-linux" = {
      platform = "linux-x64";
      hash = "sha256-awQsgq1njVvdaF4RX4tEMa+LXi4MRd3MWlc424ePX7w=";
    };
    "aarch64-linux" = {
      platform = "linux-aarch64";
      hash = "sha256-3b1ewCH3rCkAH2hqJKwcUgJ3VPQzoVBNKl9Br6PiChA=";
    };
    "x86_64-darwin" = {
      platform = "mac-x64";
      hash = "sha256-Ziwu7roFZmWMXIJX5fGP4eMsRYhJ6AnchCZZ/zpZaPY=";
    };
    "aarch64-darwin" = {
      platform = "mac-aarch64";
      hash = "sha256-PheDfIJ9Eya5BQck84x43VDImi7yRleW84Eebcsfma0=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
vscode-utils.buildVscodeExtension {
  pname = "kotlin";
  inherit version;
  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-lsp-${version}-${source.platform}.vsix";
    inherit (source) hash;
  };
  vscodeExtPublisher = "JetBrains";
  vscodeExtName = "kotlin";
  vscodeExtUniqueId = "JetBrains.kotlin";

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration |= map(
      if .properties."kotlinLSP.jrePathToRunLsp" then
        .properties."kotlinLSP.jrePathToRunLsp".default = "${openjdk21}"
      else . end
    )' package.json | sponge package.json

    # Remove bundled JRE (using nixpkgs openjdk21 instead)
    rm -rf server/jre
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Official Kotlin Language Server extension for VSCode from JetBrains";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    platforms = builtins.attrNames sources;
    maintainers = with lib.maintainers; [ imsugeno ];
  };
}
