{
  lib,
  stdenvNoCC,
  fetchurl,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "2026.8.18";

  throwSystem = throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-x86_64-unknown-linux.tar.gz";
      hash = "sha256-3Uu6IFkwhr9whHR5LBGrDJQovlskGf9cGC7F8QmaBmE=";
    };

    aarch64-linux = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-aarch64-unknown-linux.tar.gz";
      hash = "sha256-En56i68uCcsP0jhxr5idyeMuO/p/SXsfZWDMUvW/GcY=";
    };

    aarch64-darwin = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-aarch64-apple-darwin.tar.gz";
      hash = "sha256-n0GtTUnA9OYw4VmAQkGA4rcOGk9ifwYz+ouyJEkZpAo=";
    };

    x86_64-darwin = fetchurl {
      url = "https://static.devin.ai/cli/${version}/devin-${version}-x86_64-apple-darwin.tar.gz";
      hash = "sha256-KZ7FeZjOIR+/vW7Tt3BOBQUsShXOglaRbxxGSR6R2Bg=";
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
