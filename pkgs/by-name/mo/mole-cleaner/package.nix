{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  coreutils,
  gawk,
  gdu,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  version = "1.21.0";

  binaries = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/tw93/Mole/releases/download/V${version}/binaries-darwin-arm64.tar.gz";
      hash = "sha256-cIZslu8rxPpP516f/PAtytuR9lJIbB9jOrY2Bnl8ilY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/tw93/Mole/releases/download/V${version}/binaries-darwin-amd64.tar.gz";
      hash = "sha256-YVJJrU2rCw8L5cNT2agBXIY3KDDqHEZdMOWa0rG0vYA=";
    };
  };

in
stdenvNoCC.mkDerivation {
  pname = "mole-cleaner";
  inherit version;

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Mole";
    tag = "V${version}";
    hash = "sha256-HAKlivpOIpQ6vtEmyiFT33j4LzXahAqQGA3DwrU2bis=";
  };

  dontBuild = true;

  postPatch = ''
    substituteInPlace mole \
      --replace-fail 'set -euo pipefail' \
        'set -euo pipefail
    export PATH="${
      lib.makeBinPath [
        coreutils
        gawk
        gdu
      ]
    }:$PATH"' \
      --replace-fail 'SCRIPT_DIR="$(cd "$(dirname "''${BASH_SOURCE[0]}")" && pwd)"' \
        'SCRIPT_DIR="@out@/libexec/mole"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/mole $out/bin

    # Substitute @out@ placeholder in the script
    substituteInPlace mole --replace-fail '@out@' "$out"

    # Install main script, lib, and bin shell scripts
    cp mole $out/libexec/mole/
    chmod +x $out/libexec/mole/mole
    cp -r lib $out/libexec/mole/
    cp -r bin $out/libexec/mole/
    chmod +x $out/libexec/mole/bin/*.sh

    # Install pre-built Go binaries to bin/ subdirectory and rename them
    tar -xzf ${binaries.${stdenvNoCC.hostPlatform.system}} -C $out/libexec/mole/bin
    mv $out/libexec/mole/bin/analyze-* $out/libexec/mole/bin/analyze-go
    mv $out/libexec/mole/bin/status-* $out/libexec/mole/bin/status-go

    # Create symlink in bin
    ln -s $out/libexec/mole/mole $out/bin/mole

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI tool for cleaning and optimizing macOS";
    homepage = "https://github.com/tw93/Mole";
    changelog = "https://github.com/tw93/Mole/releases/tag/V${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.djedlajn ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "mole";
  };
}
