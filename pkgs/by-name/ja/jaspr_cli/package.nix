{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  versionCheckHook,
  callPackage,
  yq-go,
  testers,
  jaspr_cli,
}:
buildDartApplication rec {
  pname = "jaspr_cli";
  version = "0.22.3";

  # Fetch the whole monorepo
  src = fetchFromGitHub {
    owner = "schultek";
    repo = "jaspr";
    tag = "jaspr_cli-v${version}";
    hash = "sha256-9o/axtR+ho5xfxrJks7mArIPPNp/HMvZbxuMal4avRg=";
  };

  sourceRoot = "${src.name}/packages/jaspr_cli";

  dartEntryPoints = {
    "bin/jaspr" = "bin/jaspr.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [ yq-go ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  # Remove the resolution: workspace section.
  # Workspace dependencies break the Nix build which expects
  # all dependencies to be resolved via the lockfile.
  preBuild = ''
    yq -i 'del(.resolution)' pubspec.yaml
  '';

  passthru = {
    updateScript = lib.getExe (callPackage ./update.nix { });

    tests = {
      # Basic execution test
      help-text = testers.runCommand {
        name = "jaspr-cli-help-test";
        buildInputs = [ jaspr_cli ];
        script = ''
          jaspr --help | grep "Usage: jaspr"
          touch $out
        '';
      };

      # Smoke test: Can it initialize a project?
      # Note: Using --no-pub-get because Nix has no network access
      create-project = testers.runCommand {
        name = "jaspr-cli-create-test";
        buildInputs = [ jaspr_cli ];
        script = ''
          export HOME=$TMPDIR
          jaspr create -t docs my_test_project --no-pub-get
          test -f my_test_project/pubspec.yaml
          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "jaspr";
    homepage = "https://jaspr.site";
    description = "Command line tools for Jaspr";
    longDescription = ''
      Command line tools for the Jaspr, a modern web framework for building websites in Dart. Supports SPAs, SSR and SSG.
    '';
    changelog = "https://pub.dev/packages/jaspr_cli/changelog#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers.cpeParts = lib.meta.cpePatchVersionInUpdateWithVendor "schultek" version;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
}
