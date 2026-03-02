{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  callPackage,
  makeWrapper,
  flutter,
  dart,
}:
buildDartApplication rec {
  pname = "pana";
  version = "0.23.10";

  src = fetchFromGitHub {
    owner = "dart-lang";
    repo = "pana";
    tag = version;
    hash = "sha256-opkHUmfFbFHD1Gfx055YGNnxMoFFsTZvd/8VRN90HGA=";
  };

  dartEntryPoints = {
    "bin/pana" = "bin/pana.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # 1. Create a directory in the store to hold the license text files
    mkdir -p $out/share/pana/spdx-licenses

    # 2. Copy the .txt files from the source tree into the store
    # These are the files pana needs to perform license detection
    cp lib/src/third_party/spdx/licenses/*.txt $out/share/pana/spdx-licenses/

    # 3. Wrap the binary to always know where its data is and
    # where the dart-sdk and flutter-sdk are
    wrapProgram $out/bin/pana \
      --set FLUTTER_ROOT "${flutter}" \
      --prefix PATH : "${
        lib.makeBinPath [
          dart
          flutter
        ]
      }" \
      --add-flags "--dart-sdk ${dart} --flutter-sdk ${flutter} --license-data $out/share/pana/spdx-licenses"
  '';

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });
    tests = callPackage ./tests.nix { };
  };

  meta = {
    mainProgram = "pana";
    homepage = "https://pub.dev/packages/pana";
    description = "Package ANAlysis for Dart";
    longDescription = ''
      Package ANAlyzer - produce a report summarizing the health and quality of a Dart package.
    '';
    changelog = "https://pub.dev/packages/pana/changelog#${lib.replaceStrings [ "." ] [ "" ] version}";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers.cpeParts =
      let
        versionSplit = lib.split "\\+" version;
        versionPart = lib.elemAt versionSplit 0;
        updatePart =
          if lib.count (x: lib.isList x) versionSplit > 0 then lib.elemAt versionSplit 2 else "*";
      in
      {
        vendor = "dart-lang";
        product = "pana";
        version = versionPart;
        update = updatePart;
      };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
}
