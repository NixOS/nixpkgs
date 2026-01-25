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
      url = "https://downloads.cursor.com/lab/2026.01.23-916f423/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-XfN1Fm1Rvo6GDRVtyzRV/+mkSZuJbp8dEoOn8pH1RnQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.23-916f423/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-1y2IBypnoCHWFmYrmGxp49oXmMew+fBffBKiorWsJ/E=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.23-916f423/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-MuRxnITcZl2JphP+vcqRZo1JTr9mSTNjZKs3DPvxsE0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.23-916f423/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-vTOszoUW4LWUHlKwwexQRH1Uy5CcvN3el6y1jRfBCeM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-01-23";

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
