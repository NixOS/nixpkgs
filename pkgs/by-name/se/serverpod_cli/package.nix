{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  yq-go,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
buildDartApplication rec {
  pname = "serverpod_cli";
  version = "3.3.1";

  # Fetch the whole monorepo
  src = fetchFromGitHub {
    owner = "serverpod";
    repo = "serverpod";
    rev = version;
    hash = "sha256-4vpZiqvzhcAziElfzssw4bLYTO5/dhai3C8LEpn0eAo=";
  };

  sourceRoot = "${src.name}/tools/serverpod_cli";

  dartEntryPoints = {
    "bin/serverpod" = "bin/serverpod_cli.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ yq-go ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;

  versionCheckKeepEnvironment = "HOME";

  preBuild = ''
    # Set productionMode to true.
    substituteInPlace lib/src/generated/version.dart \
      --replace-fail "const productionMode = false;" "const productionMode = true;"

    # Remove the dependency_overrides section.
    # Relative path overrides in the monorepo break the Nix build which expects
    # all dependencies to be resolved via the lockfile.
    yq -i 'del(.dependency_overrides)' pubspec.yaml
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    mainProgram = "serverpod";
    homepage = "https://serverpod.dev";
    description = "Command line tools for Serverpod";
    longDescription = ''
      Serverpod is a next-generation app and web server,
      built for the Flutter community.
      It allows you to write your server-side code in Dart,
      automatically generate your APIs, and hook up your
      database with minimal effort. Serverpod is open-source,
      and you can host your server anywhere.
    '';
    changelog = "https://raw.githubusercontent.com/serverpod/serverpod/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
}
