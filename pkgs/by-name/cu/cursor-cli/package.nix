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
      url = "https://downloads.cursor.com/lab/2026.10.22-27dcf5f/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-hSlpRORgCoPEt2T1eNFQK/nEFtsgDTOlk+jz7Kv9wpQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.10.22-27dcf5f/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-IqNt+XIIMGaMzU1wflGQIEq5yKDvsvBozJFIlfgE0+w=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.10.22-27dcf5f/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-L1sKPdX7lRzs/6yBOGfYoI2BDlmDfVn9XxLWm5IjmNc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-10-22";

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
