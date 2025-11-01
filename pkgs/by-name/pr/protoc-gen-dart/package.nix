{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "protoc-gen-dart";
  version = "23.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf.dart";
    tag = "protoc_plugin-v${version}";
    hash = "sha256-fNPc9flfHL1Q7mQ6sXapWmw2OnizaUCIlx8/Yg/FTqk=";
  };

  sourceRoot = "${src.name}/protoc_plugin";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Protobuf plugin for generating Dart code";
    mainProgram = "protoc-gen-dart";
    homepage = "https://pub.dev/packages/protoc_plugin";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}
