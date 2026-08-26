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
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "conceptadev";
    repo = "fvm";
    tag = version;
    hash = "sha256-SAWWKNbE/TyrP5bcIdDeAZa6/3d4D/Ru1PbcPvy9EDo=";
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
}
