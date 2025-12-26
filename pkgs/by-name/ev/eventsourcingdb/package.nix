{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "eventsourcingdb";
  version = "1.2.0";

  src =
    let
      srcs = {
        x86_64-linux = fetchurl {
          url = "https://web.archive.org/web/20251223112723/https://eventsourcingdb.s3.fr-par.scw.cloud/eventsourcingdb-linux-amd64";
          hash = "sha256-FDr6mn1JiRG9jZNz+z+hAAyucM5AV1rmDuEZy5jZ82U=";
        };

        aarch64-linux = fetchurl {
          url = "https://web.archive.org/web/20251223111810/https://eventsourcingdb.s3.fr-par.scw.cloud/eventsourcingdb-linux-arm64";
          hash = "sha256-/ObI789jqkP4wnPIfq7TuRO/1DZmQdmzfH9AL8XA2C4=";
        };
      };
    in
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

  meta = with lib; {
    description = "Database for event sourcing";
    homepage = "https://eventsourcingdb.io/";
    changelog = "https://docs.eventsourcingdb.io/about-eventsourcingdb/changelog";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ badmomber ];
    mainProgram = "eventsourcingdb";
  };
}
