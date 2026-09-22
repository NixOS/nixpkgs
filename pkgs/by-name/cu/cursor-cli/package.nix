{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  zlib,
}:

let
  inherit (stdenv) hostPlatform;
  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.09.10-fd3934a/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-J5l8g5GthTpacysYRduO+CqLpq+w94KcxzlGT4lm6W4=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.09.10-fd3934a/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-4ElEOLAcN7w0hISR0fNHjvRpSUxWyvAg3hF5bRRttko=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.09.10-fd3934a/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-rsCwGuBW3kigL+MV+/BYDrkTd3UtmTMHSZmIy+AoVCM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-09-10";

  src = sources.${hostPlatform.system};

  buildInputs = lib.optionals hostPlatform.isLinux [
    zlib
  ];

  nativeBuildInputs = lib.optionals hostPlatform.isLinux [
    autoPatchelfHook
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/cursor-agent
    cp -r * $out/share/cursor-agent/
    ln -s $out/share/cursor-agent/cursor-agent $out/bin/cursor-agent

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Cursor CLI";
    homepage = "https://cursor.com/cli";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      sudosubin
      andrewbastin
    ];
    platforms = builtins.attrNames sources;
    mainProgram = "cursor-agent";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
