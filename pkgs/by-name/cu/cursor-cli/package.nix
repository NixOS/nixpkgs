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
      url = "https://downloads.cursor.com/lab/2026.04.08-a41fba1/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-zHNiy5I61cN6BpfRv1TozdRk+2R/RNxIanCPkwqdfZE=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.04.08-a41fba1/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-xcbIoTunBlL79SgE8h5PeT4HwguHY0UUQTiYdtppv7c=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.04.08-a41fba1/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-O9OoPaBBHAAazYnEvHSB8okyDHdEqMu1A0CbUwsw93I=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.04.08-a41fba1/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-TGyQxZbn5yGTjqqfrbKRGXCp9MhuEHSV6oNZOIEoZDA=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-04-08";

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
