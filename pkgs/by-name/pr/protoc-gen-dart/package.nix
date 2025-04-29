{
  lib,
  fetchFromGitHub,
  buildDartApplication,
}:

buildDartApplication rec {
  pname = "protoc-gen-dart";
  version = "21.1.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf.dart";
    tag = "protoc_plugin-v${version}";
    hash = "sha256-luptbRgOtOBapWmyIJ35GqOClpcmDuKSPu3QoDfp2FU=";
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
