{
  lib,
  stdenv,
  fetchzip,
  buildNpmPackage,
  clang_20,

  patches ? [ ],
}:

let
  releaseData = (lib.importJSON ./release-data.json).plugins."io.github.jackgruber.backup";
in

buildNpmPackage {
  name = "joplin-plugin-backup";

  inherit (releaseData) npmDepsHash;
  inherit patches;

  src = fetchzip {
    inherit (releaseData) url hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    clang_20 # clang_21 breaks keytar
  ];

  npmBuildScript = "dist";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out publish/*.jpl

    runHook postInstall
  '';
}
