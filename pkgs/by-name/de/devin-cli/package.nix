{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "2026.5.26-2";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-x86_64-unknown-linux.tar.gz";
      hash = "sha256-5647gIz60Dj/mZ4bALJsWnAyWfXQO33vG6kqy2hHp84=";
    };

    aarch64-linux = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-aarch64-unknown-linux.tar.gz";
      hash = "sha256-8D61SCYC3VMbSwgRpWm8IKD1PQwbKT/EMejSFq5qsds=";
    };

    aarch64-darwin = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-aarch64-apple-darwin.tar.gz";
      hash = "sha256-1MRFAWZKPCMfEm1zPGDHBoq4zAYXsIGTlrXwTkZH9c0=";
    };

    x86_64-darwin = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-x86_64-apple-darwin.tar.gz";
      hash = "sha256-B3LsnLXyExTagVC7UibsQTxk5u6KmYzgr2LtAJemSyo=";
    };
  };

  src = srcs.${stdenvNoCC.hostPlatform.system} or throwSystem;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "devin-cli";
  inherit version;

  outputs = [
    "out"
    "man"
    "doc"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  inherit src;

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;
  dontStrip = true;
  dontBuild = true;

  doCheck = true;

  installPhase = ''
    runHook preInstall

    installBin ./bin/devin
    installManPage ./share/man/man1/*.1

    mkdir -p $out/share/doc

    mv ./share/devin/docs/* $out/share/doc

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cognition's Devin Agent CLI";
    homepage = "https://devin.ai/cli";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with lib.maintainers; [
      ethancedwards8
      nhshah15
    ];
    mainProgram = "devin";
  };
})
