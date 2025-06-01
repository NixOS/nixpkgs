{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "melos";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${version}";
    hash = "sha256-bhiqnBohDalUzjbrLvCWj15E4m30gluBcdxUe7xc2Zk=";
  };

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
    mkdir -p $out
    cp -r templates $out/
  '';

  meta = {
    homepage = "https://github.com/invertase/melos";
    description = "Tool for managing Dart projects with multiple packages";
    mainProgram = "melos";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eymeric ];
  };
}
