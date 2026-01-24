{
  lib,
  fetchFromGitHub,
  flutter338,
  sqlite,
  libsecret,
  _experimental-update-script-combinators,
  nix-update-script,
  runCommand,
  yq-go,
  dart,
}:

let
  version = "1.23.6+145";

  src = fetchFromGitHub {
    owner = "FriesI23";
    repo = "mhabit";
    tag = "v${version}";
    hash = "sha256-9+UXMOogySW3f9LPaj0YSfov1cSgLb3I+jWvAV8yEsM=";
  };
in
flutter338.buildFlutterApplication {
  pname = "mhabit";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  buildInputs = [
    sqlite
    libsecret
  ];

  # https://github.com/juliansteenbakker/flutter_secure_storage/issues/965
  CXXFLAGS = [ "-Wno-deprecated-literal-operator" ];

  postInstall = ''
    install -Dm644 flatpak/io.github.friesi23.mhabit.desktop --target-directory=$out/share/applications
    install -Dm644 assets/logo/icon.svg $out/share/icons/hicolor/scalable/io.github.friesi23.mhabit
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
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "mhabit.pubspecSource" ./pubspec.lock.json)
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
    description = "Track micro habits with easy-to-use charts and tools";
    longDescription = ''
      "Table Habit" is an app that helps you establish and track your
      own micro habit. It includes a complete set of growth curves and
      charts to help you build habits more effectively, and keeps your
      data in sync across devices (currently via WebDAV, with more
      options coming soon).
    '';
    homepage = "https://github.com/FriesI23/mhabit";
    changelog = "https://github.com/FriesI23/mhabit/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "mhabit";
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
}
