{
  lib,
  stdenvNoCC,
  fetchurl,
  writeTextFile,
  autoPatchelfHook,
  isabelle,
}:

let
  inherit (isabelle) platform;
  inherit (stdenvNoCC.hostPlatform) isDarwin extensions;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zstd-jni";
  version = "1.5.7-6";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/zstd-jni-${finalAttrs.version}.tar.gz";
    hash = "sha256-dYqd//VkrvHYNScz4MNINhx7q/0RM8joYDC/NL+DBmc=";
  };

  nativeBuildInputs = lib.optionals (!isDarwin) [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/${platform}"
    cp lib/*.jar "$out/lib"
    cp ${platform}/*${extensions.sharedLibrary} "$out/${platform}"

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "zstd-jni-settings";
    text = ''
      ISABELLE_ZSTD_HOME="${finalAttrs.finalPackage}"

      classpath "$ISABELLE_ZSTD_HOME/lib/zstd-jni-${finalAttrs.version}.jar"
    '';
    destination = "/etc/settings";
  };
})
