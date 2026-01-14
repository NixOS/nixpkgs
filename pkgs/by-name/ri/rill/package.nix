{ lib
, stdenv
, fetchzip
, autoPatchelfHook
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rill";
  version = "0.46.6";
  src = fetchzip {
    url = "https://github.com/rilldata/rill/releases/download/v${finalAttrs.version}/rill_linux_amd64.zip";
    hash = "sha256-lrm7OLO6I16QjQejDjsHQQPAKdJhJPuA2JnWs3i49l8=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

      mkdir -p $out/bin
      cp rill $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.rilldata.com";
    description = "Effortlessly transforming data sets into powerful, opinionated dashboards using SQL";
    maintainers = with lib.maintainers; [ ByteSudoer ];
    platforms = [ "x86_64-linux" ];
    license = with lib.licenses;[ apsl20 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "rill";
  };
})
