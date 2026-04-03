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
      url = "https://downloads.cursor.com/lab/2026.03.18-f6873f7/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-O0dcGKyTryFBiSCIoUtsBoWKBCdgj3Rc178nbaxFu64=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.18-f6873f7/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-JpSeyfrpX9vcAu3ymn4hBlomuRGnowVFXQ58NaCoSz8=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.18-f6873f7/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-ubEakI8t3/BJ9eVcYueGEg7RWhvTjWbJMGNweyF9V0E=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.18-f6873f7/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-KHybHgQrIOBHbiJZSEbFVG0Fp1+TRPvK75JXPcSTMKk=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-03-18";

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
