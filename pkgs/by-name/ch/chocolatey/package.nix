{
  lib,
  stdenv,
  coreutils,
  fetchurl,
  makeWrapper,
  mono,
  testers,
  chocolatey,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chocolatey";
  version = "2.7.2";

  src = fetchurl {
    url = "https://github.com/chocolatey/choco/releases/download/${finalAttrs.version}/chocolatey.v${finalAttrs.version}.tar.gz";
    hash = "sha256-x29mz/qyQqWb3PaciOBb9MjWQw9OX5yfXEXZdz/1v3s=";
  };

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/chocolatey
    cp -r . $out/share/chocolatey
    makeWrapper ${lib.getExe mono} $out/bin/choco \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
      --run 'runtimeDir="''${CHOCOLATEY_NIX_STATE:-''${XDG_CACHE_HOME:-$HOME/.cache}/chocolatey-nix/${finalAttrs.version}}"' \
      --run 'if [ ! -e "$runtimeDir/choco.exe" ]; then rm -rf "$runtimeDir"; mkdir -p "$runtimeDir"; cp -R '"$out"'/share/chocolatey/. "$runtimeDir/"; chmod -R u+w "$runtimeDir"; fi' \
      --run 'cd "$runtimeDir"' \
      --add-flags "choco.exe"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = chocolatey;
      command = "HOME=$(mktemp -d) choco --version";
      version = finalAttrs.version;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Package manager for Windows";
    homepage = "https://chocolatey.org/";
    changelog = "https://github.com/chocolatey/choco/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "choco";
    inherit (mono.meta) platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
