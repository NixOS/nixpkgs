{
  lib,
  fetchFromGitHub,
  buildDartApplication,
}:
let
  version = "7.3.0";
  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${version}";
    hash = "sha256-XTEhH8F54BoXJ1QNhUIZszHQoDwP0Za1LPQ6Dv9sR08=";
  };
in
buildDartApplication {
  pname = "melos";
  inherit version src;

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

  meta = {
    homepage = "https://github.com/invertase/melos";
    description = "Tool for managing Dart projects with multiple packages";
    mainProgram = "melos";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
