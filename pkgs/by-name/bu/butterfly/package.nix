{
  lib,
  flutter335,
  fetchFromGitHub,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  gitUpdater,
  dart,
}:

let
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    tag = "v${version}";
    hash = "sha256-izoxMMvNjcgBPpc0kvhv4OIuqa1OHvmeoqFKrVgp0bE=";
  };
in
flutter335.buildFlutterApplication {
  pname = "butterfly";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

  gitHashes = lib.importJSON ./git-hashes.json;

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
          yq eval --output-format=json --prettyPrint $src/app/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (
        (gitUpdater {
          ignoredVersions = ".*(rc|beta).*";
          rev-prefix = "v";
        })
        // {
          supportedFeatures = [ ];
        }
      )
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "butterfly.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
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
    maintainers = [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
