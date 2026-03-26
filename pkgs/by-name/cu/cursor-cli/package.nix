{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
}:

let
  inherit (stdenv) hostPlatform;
  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.25-933d5a6/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-sLNUNy95Ro953X4tha0fPj/M8DRN4Txn34m2kWa/J/U=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.25-933d5a6/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-+Gk7XDf294AxHYwig2s7h4DSgy2Sf5F5Va+c5ufDbtw=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.25-933d5a6/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-JDUMpdFEnPgYJWjXXIsdqOVbkw6DbcahbcCVYjbqKxo=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.25-933d5a6/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-1QTjO99QvdviRsos5pvOrfR2L1fwj6nBh0nPqcY1qnI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-03-25";

  src = sources.${hostPlatform.system};

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
