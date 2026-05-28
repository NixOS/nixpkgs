{
  lib,
  fetchFromGitHub,
  buildDartApplication,
}:
buildDartApplication (finalAttrs: {
  pname = "melos";
  version = "7.4.1";
  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${finalAttrs.version}";
    hash = "sha256-bsNPZd1euOKF2LlAmBIkr+0iO51iAkcIZYrd5oUJTKo=";
  };

  patches = [
    # Patch melos entrypoint to bypass cli_launcher which throws because it does not find melos in the "classic" folders eg : .dart_tool or pub cache.
    # https://github.com/blaugold/cli_launcher/blob/dcdf11c42b77ddc8e38e7e2445c8cff9b55658ec/lib/cli_launcher.dart#L236
    ./add-generic-main.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # hard code the path to the melos templates
  preBuild = ''
    substituteInPlace packages/melos/lib/src/common/utils.dart \
      --replace-fail "final melosPackageFileUri = await Isolate.resolvePackageUri(melosPackageUri);" "return \"$out\";"
    substituteInPlace packages/melos/lib/src/common/utils.dart \
      --replace-fail "return p.normalize('\''${melosPackageFileUri!.toFilePath()}/../..');" " "
    mkdir --parents $out
    cp --recursive packages/melos/templates $out/
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
    homepage = "https://github.com/invertase/melos";
    description = "Tool for managing Dart projects with multiple packages";
    mainProgram = "melos";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eymeric ];
  };
})
