{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

buildDartApplication (finalAttrs: {
  pname = "fvm";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "conceptadev";
    repo = "fvm";
    tag = finalAttrs.version;
    hash = "sha256-SAWWKNbE/TyrP5bcIdDeAZa6/3d4D/Ru1PbcPvy9EDo=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "fvm.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = {
    description = "Simple CLI to manage Flutter SDK versions";
    homepage = "https://github.com/conceptadev/fvm";
    license = lib.licenses.mit;
    mainProgram = "fvm";
    maintainers = [ ];
  };
})
