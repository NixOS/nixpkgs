{ stdenv
, dart
, jq
}:
deps:

builtins.fromJSON (builtins.readFile (stdenv.mkDerivation {
  name = "${deps.name}-list.json";
  nativeBuildInputs = [ deps dart jq ];

  unpackPhase = ''
    runHook preUnpack
    ln -s "${deps.files}"/pubspec/* .
    runHook postUnpack
  '';

  configurePhase = ''
    runHook preConfigure
    dart pub get --offline
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    dart pub deps --json | jq .packages > $out
    runHook postBuild
  '';
}))
