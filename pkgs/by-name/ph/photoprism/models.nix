{
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

  outputHash = "sha256-1llL1wlV3ulXmFG9BVYeCxbpmJIfro+wwY5lrydrAhw=";
  outputHashMode = "recursive";

  nativeBuildInputs = [
    wget
    unzip
  ];

  buildCommand = ''
    patchShebangs --host ./scripts/dist/download-models.sh
    MODELS_PATH="$out" ./scripts/dist/download-models.sh --no-backup facenet nasnet nsfw sface yunet
  '';

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
