{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flywheel-cli";
  version = "16.2.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/flywheel-dist/cli/${finalAttrs.version}/fw-linux_amd64-${finalAttrs.version}.zip";
    hash = "sha256-SxBjRd95hoh2zwX6IDnkZnTWVduQafPHvnWw8qTuM78=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip ${finalAttrs.src}
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin ./linux_amd64/fw
    runHook postInstall
  '';

  meta = {
    description = "Library and command line interface for interacting with a Flywheel site";
    mainProgram = "fw";
    homepage = "https://gitlab.com/flywheel-io/public/python-cli";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rbreslow ];
    platforms = [
      "x86_64-linux"
    ];
  };
})
