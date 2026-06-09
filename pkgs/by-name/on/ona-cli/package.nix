{
  lib,
  stdenvNoCC,
  fetchurl,
  versionCheckHook,
}:

let
  stdenv = stdenvNoCC;

  platform =
    {
      aarch64-darwin = "darwin-arm64";
      aarch64-linux = "linux-arm64";
      x86_64-darwin = "darwin-amd64";
      x86_64-linux = "linux-amd64";
    }
    .${stdenv.hostPlatform.system};

  hashes = {
    aarch64-darwin = "sha256-qMmR5vD+qK61eb5zXZhl7taOUIS3i0wDm57m40cmZ0M=";
    aarch64-linux = "sha256-45S7PM3X3Q8/IksfWwHPSwpqp9oFZFF2iFvPLAoDd2M=";
    x86_64-darwin = "sha256-c0fWI6OeqBCqtyO4JAGiS9FyaZgkpOI6JjPgLzxKCPU=";
    x86_64-linux = "sha256-Je5I5TA8I+mwGOvlGResP8u+DcZKz2LhxtZ6MAvv46k=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ona-cli";
  version = "20260522.11804.0";

  src = fetchurl {
    url = "https://releases.gitpod.io/cli/releases/${finalAttrs.version}/gitpod-${platform}";
    hash = hashes.${stdenv.hostPlatform.system};
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${finalAttrs.src} $out/bin/ona

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CLI for Ona development environments";
    homepage = "https://ona.com";
    license = lib.licenses.unfree;
    mainProgram = "ona";
    maintainers = [ lib.maintainers.filiptronicek ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
