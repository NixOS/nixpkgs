{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  versionCheckHook,
  callPackage,
}:
buildDartApplication (finalAttrs: {
  pname = "dart_frog_cli";
  version = "1.2.14";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dart-frog-dev";
    repo = "dart_frog";
    tag = "dart_frog_cli-v${finalAttrs.version}";
    hash = "sha256-B5ET/SwQzYw251Ox/RyuLM27+M//xTehke9JJSD7Gf8=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/dart_frog_cli";

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
    # If your tests.nix needs the package itself, pass finalAttrs.finalPackage
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
      lib.replaceString "." "" finalAttrs.version
    }";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "dart-frog-dev" finalAttrs.version;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
