{
  cacert,
  lib,
  nix-update-script,
  src,
  stdenv,
  unzip,
  version,
  wget,
}:

stdenv.mkDerivation {
  inherit src version;
  pname = "photoprism-models";

  outputHash = "sha256-/vxvQO0yOBV5auGeJ3+RQJuqc3z748vfXkTc7SIsOXI=";
  outputHashMode = "recursive";

  nativeBuildInputs = [
    cacert
    wget
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs --host ./scripts/dist/download-models.sh
    MODELS_PATH="$out" ./scripts/dist/download-models.sh --no-backup facenet nasnet nsfw sface yunet

    runHook postBuild
  '';

  dontInstall = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://photoprism.app";
    description = "Photoprism's models";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ipetkov
    ];
  };
}
