{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  versionCheckHook,
  callPackage,
}:
buildDartApplication rec {
  pname = "dart_frog_cli";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "dart-frog-dev";
    repo = "dart_frog";
    tag = "dart_frog_cli-v${version}";
    hash = "sha256-Wf6pIZ6kwEasvzAUha/xaK6grW9vEb345E7Q2Bt4X8g=";
  };

  sourceRoot = "${src.name}/packages/dart_frog_cli";

  dartEntryPoints = {
    "bin/dart_frog" = "bin/dart_frog.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  preBuild = ''
    rm pubspec_overrides.yaml
  '';

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });
    tests = callPackage ./tests.nix { };
  };

  meta = {
    mainProgram = "dart_frog";
    homepage = "https://dart-frog.dev";
    description = "Command line tools for Dart Frog";
    longDescription = ''
      The official command line interface for Dart Frog — a fast, minimalistic backend framework for Dart.
    '';
    changelog = "https://pub.dev/packages/dart_frog_cli/changelog#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers.cpeParts = lib.meta.cpePatchVersionInUpdateWithVendor "dart-frog-dev" version;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
}
