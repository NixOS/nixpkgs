{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "3000.4.25";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-x86_64-unknown-linux.tar.gz";
      hash = "sha256-Aq6GxMUC1fFnYXVmPb7TbvLAdQpOCUxRKUhFIo7qxdo=";
    };

    aarch64-linux = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-aarch64-unknown-linux.tar.gz";
      hash = "sha256-MeQCD4pNwE6A5IV3DLRnJw/3yLFVlcA7z0H3iBe8LpM=";
    };

    aarch64-darwin = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-aarch64-apple-darwin.tar.gz";
      hash = "sha256-ez6pjS9Q3v3lMshwAJ131MctcR6XzYwx+4tO2zpyeSw=";
    };
  };
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

  src = srcs.${stdenvNoCC.hostPlatform.system} or throwSystem;

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;
  dontBuild = true;

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
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      ethancedwards8
      nhshah15
    ];
    mainProgram = "devin";
  };
})
