{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m1ddc";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "waydabber";
    repo = "m1ddc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-obs2qQvSkIDsWhCXJOF1Geiqqy19KDf0InyxRVod4hk=";
  };

  postPatch = ''
    substituteInPlace sources/ioregistry.m \
        --replace-fail kIOMainPortDefault kIOMasterPortDefault
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp m1ddc $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Control external displays using DDC/CI on Apple Silicon Macs";
    homepage = "https://github.com/waydabber/m1ddc";
    license = lib.licenses.mit;
    mainProgram = "m1ddc";
    maintainers = [ lib.maintainers.joanmassachs ];
    platforms = [ "aarch64-darwin" ];
  };
})
