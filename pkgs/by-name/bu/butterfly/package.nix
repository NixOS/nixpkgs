{
  lib,
  flutter332,
  fetchFromGitHub,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  gitUpdater,
}:

let
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    tag = "v${version}";
    hash = "sha256-3cDT1t74SrDUqUtFmNZFQHUx+eCdDjZhPseT3lhNOYE=";
  };
in
flutter332.buildFlutterApplication {
  pname = "butterfly";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

  gitHashes = lib.importJSON ./gitHashes.json;

  postInstall = ''
    cp -r linux/debian/usr/share $out/share
  '';

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
      (gitUpdater {
        ignoredVersions = ".*(rc|beta).*";
        rev-prefix = "v";
      })
      (_experimental-update-script-combinators.copyAttrOutputToFile "butterfly.pubspecSource" ./pubspec.lock.json)
      {
        command = [ ./update-gitHashes.py ];
        supportedFeatures = [ "silent" ];
      }
    ];
  };

  meta = {
    description = "Note taking app where your ideas come first";
    homepage = "https://github.com/LinwoodDev/Butterfly";
    mainProgram = "butterfly";
    license = with lib.licenses; [
      agpl3Plus
      cc-by-sa-40
      asl20
    ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
