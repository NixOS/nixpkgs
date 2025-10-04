{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  version = "4.0.0-beta.2";

  src = fetchFromGitHub {
    owner = "leoafarias";
    repo = "fvm";
    tag = "v${version}";
    hash = "sha256-Rzmsk5MibO+kB8Oou9pHRT4DymvAnORtio8gQDUST/w=";
  };
in
buildDartApplication {
  pname = "fvm";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { extraArgs = [ "--version=unstable" ]; })
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
    homepage = "https://github.com/leoafarias/fvm";
    license = lib.licenses.mit;
    mainProgram = "fvm";
    maintainers = with lib.maintainers; [ ];
  };
}
