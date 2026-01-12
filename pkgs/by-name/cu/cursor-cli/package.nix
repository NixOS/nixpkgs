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
      url = "https://downloads.cursor.com/lab/2026.01.09-231024f/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-FT4dPRYXWVLnl02KevhiMuh6F3P9Bu+YJXiWrQtH2vo=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.09-231024f/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-23P7GxKzb66HNYasW87wgSFvL7PseXrZJ29Gewqx1O0=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.09-231024f/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-kYXTaddjTkuz+tzWJHU4Bk80jABTbQdVKLjEKvSBgX8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.09-231024f/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-wOPvhIOkg8NQch5GLe5JbK2Xl2vTboVCPPMa+aMV+MI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-01-09";

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
