{
  lib,
  fetchFromGitHub,
  buildDartApplication,
}:
let
  version = "7.1.1";
  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${version}";
    hash = "sha256-i75fbo0lqDszo2pDtkWXQMt+3IoWsK7t05YU2IjqTmw=";
  };
in
buildDartApplication {
  pname = "melos";
  inherit version src;

  sourceRoot = "${src.name}/packages/melos";

  patches = [
    # This patch (created a melos 6.1.0) modify the method melos use to find path to the root of the projects.
    # It is needed because when melos is in the nixstore, it break it and fail to find the projects root with melos.yaml
    ./add-generic-main.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # hard code the path to the melos templates
  preBuild = ''
    substituteInPlace lib/src/common/utils.dart \
      --replace-fail "final melosPackageFileUri = await Isolate.resolvePackageUri(melosPackageUri);" "return \"$out\";"
    substituteInPlace lib/src/common/utils.dart \
      --replace-fail "return p.normalize('\''${melosPackageFileUri!.toFilePath()}/../..');" " "
    mkdir --parents $out
    cp --recursive templates $out/
  '';

  meta = {
    homepage = "https://github.com/invertase/melos";
    description = "Tool for managing Dart projects with multiple packages";
    mainProgram = "melos";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
