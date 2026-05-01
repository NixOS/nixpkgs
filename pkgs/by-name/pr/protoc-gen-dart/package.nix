{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  gitUpdater,
  writeShellScript,
  dart,
  yq-go,
}:

buildDartApplication rec {
  pname = "protoc-gen-dart";
  version = "24.0.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf.dart";
    tag = "protoc_plugin-v${version}";
    hash = "sha256-DEuvwBJhSo4o5ydnutxv2PCIRgS+2dE7u3RleidhAUM=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  preBuild = ''
    pushd protoc_plugin
  '';

  postInstall = ''
    popd
  '';

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (gitUpdater { rev-prefix = "protoc_plugin-v"; } // { supportedFeatures = [ ]; })
    (writeShellScript "update-protoc-gen-dart" ''
      src=$(nix build --print-out-paths --no-link .#protoc-gen-dart.src)
      export HOME=$(mktemp -d)
      WORKDIR=$(mktemp -d)
      cp --recursive --no-preserve=mode $src/* $WORKDIR
      PACKAGE_DIR=$(dirname $(EDITOR=echo nix edit --file . protoc-gen-dart))
      pushd $WORKDIR
      ${lib.getExe dart} pub update
      ${lib.getExe yq-go} eval --output-format=json --prettyPrint pubspec.lock > $PACKAGE_DIR/pubspec.lock.json
      popd
    '')
  ];

  meta = {
    description = "Protobuf plugin for generating Dart code";
    mainProgram = "protoc-gen-dart";
    homepage = "https://pub.dev/packages/protoc_plugin";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}
