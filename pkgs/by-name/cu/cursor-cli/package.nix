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
      url = "https://downloads.cursor.com/lab/2026.11.19-f005e9d/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-olmG6vDJMwru7FmaE5cRy58mfGRWLQc6crdR7fUWFpU=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.11.19-f005e9d/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-X/Bb4NfAt3VFdNvNZ3w1JUo/8ZDtZFfnG77g8nYjfik=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.11.19-f005e9d/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-FrszxZczcltGbTH5iEkN4zJ0fwkQ0tZLOTw2PlEObH0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-11-19";

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
