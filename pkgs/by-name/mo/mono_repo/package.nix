{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  versionCheckHook,
  callPackage,
}:
buildDartApplication (finalAttrs: {
  pname = "mono_repo";
  version = "6.6.3";

  __structuredAttrs = true;
  strictDeps = true;

  # Fetch the whole monorepo
  src = fetchFromGitHub {
    owner = "google";
    repo = "mono_repo";
    tag = "mono_repo-v${finalAttrs.version}";
    hash = "sha256-2/YJ2S3I9K5Xzje787HdJ/KxfbiBEGKU8feuHnOizn8=";
  };

  sourceRoot = "${finalAttrs.src.name}/mono_repo";

  dartEntryPoints = {
    "bin/mono_repo" = "bin/mono_repo.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = lib.getExe (callPackage ./update.nix { });

  meta = {
    mainProgram = "mono_repo";
    homepage = "https://dart.dev/tools/mono_repo";
    description = "CLI tools to make it easier to manage a single source repository containing multiple Dart packages";
    changelog = "https://pub.dev/packages/mono_repo/changelog#${
      lib.replaceString "." "" finalAttrs.version
    }";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "google" finalAttrs.version;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
