{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "1.2.0";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://eventsourcingdb.s3.fr-par.scw.cloud/${version}/eventsourcingdb-linux-amd64";
      hash = "sha256-FDr6mn1JiRG9jZNz+z+hAAyucM5AV1rmDuEZy5jZ82U=";
    };

    aarch64-linux = fetchurl {
      url = "https://eventsourcingdb.s3.fr-par.scw.cloud/${version}/eventsourcingdb-linux-arm64";
      hash = "sha256-/ObI789jqkP4wnPIfq7TuRO/1DZmQdmzfH9AL8XA2C4=";
    };
  };
in
stdenv.mkDerivation {
  pname = "eventsourcingdb";
  inherit version;
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook ];

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m755 -D $src $out/bin/eventsourcingdb

    runHook postInstall
  '';

  meta = {
    description = "Database for event sourcing";
    homepage = "https://eventsourcingdb.io/";
    changelog = "https://docs.eventsourcingdb.io/about-eventsourcingdb/changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    # https://docs.eventsourcingdb.io/about-eventsourcingdb/licensing/
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ badmomber ];
    mainProgram = "eventsourcingdb";
  };
}
