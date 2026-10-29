{
  lib,
  stdenv,
  fetchzip,
  jre_headless,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riot-redis";
  version = "2.19.0";

  src = fetchzip {
    url = "https://github.com/redis-developer/riot/releases/download/v${finalAttrs.version}/riot-redis-${finalAttrs.version}.zip";
    sha256 = "sha256-q2ZqFVdjg5HSH4kiwoC1W+a8VgHNxBgNeMaw5n97isc=";
  };

  buildInputs = [ jre_headless ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/riot-redis $out/bin
    cp -R lib $out
    chmod +x $out/bin/*

    wrapProgram $out/bin/riot-redis \
      --set JAVA_HOME "${jre_headless}"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/redis-developer/riot";
    description = "Get data in and out of Redis";
    mainProgram = "riot-redis";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ wesnel ];
  };
})
