{
  lib,
  fetchFromGitHub,
  buildDartApplication,
  versionCheckHook,
}:

buildDartApplication (finalAttrs: {
  pname = "serverpod_cli";
  version = "4.0.3"; # will be updated

  src = fetchFromGitHub {
    owner = "serverpod";
    repo = "serverpod";
    rev = finalAttrs.version;
    hash = "sha256-ZdYHYaNpPicNxce7P4Z6VYM1dKgEniSowGbccg2Tqjc="; # will be updated
  };

  sourceRoot = "${finalAttrs.src.name}/tools/serverpod_cli";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  postPatch = ''
    substituteInPlace lib/src/generated/version.dart \
      --replace-fail "const productionMode = false;" "const productionMode = true;"
  '';

  passthru = {
    updateScript = {
      command = [
        ./update.sh
        ./.
      ];
      supportedFeatures = [ "commit" ];
    };
  };

  meta = {
    homepage = "https://serverpod.dev";
    description = "Serverpod is a next-generation app and web server, written in Dart for the Flutter ecosystem";
    mainProgram = "serverpod";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.eymeric ];
  };
})
