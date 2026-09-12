{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  runCommand,
  powershell,
  scoop-installer,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "scoop-installer";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "ScoopInstaller";
    repo = "Scoop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3/fU4UGou2n4wBhj9gqRDrmdbzMd9pWuNn2gZbeCF/0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/scoop
    cp -r . $out/share/scoop

    makeWrapper ${lib.getExe powershell} $out/bin/scoop \
      --run 'export SCOOP="''${SCOOP:-$HOME/scoop}"' \
      --run 'mkdir -p "$SCOOP/shims" "$SCOOP/buckets"' \
      --add-flags "-NoLogo -NoProfile -ExecutionPolicy Bypass -File $out/share/scoop/bin/scoop.ps1"

    runHook postInstall
  '';

  passthru = {
    tests.help =
      runCommand "scoop-help-test"
        {
          name = "scoop-help-test";
          nativeBuildInputs = [ scoop-installer ];
        }
        ''
          export HOME="$PWD/home"
          scoop help > output
          grep -F "Usage: scoop <command> [<args>]" output
          touch $out
        '';
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line installer for Windows";
    homepage = "https://scoop.sh/";
    changelog = "https://github.com/ScoopInstaller/Scoop/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "scoop";
    inherit (powershell.meta) platforms;
  };
})
