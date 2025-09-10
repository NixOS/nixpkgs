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
      url = "https://downloads.cursor.com/lab/2025.09.04-fc40cd1/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-Y1ynrrHfhbmMKkbZ1C3Xl+uZy3AWnmAXwTC+OkMcquc=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.04-fc40cd1/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-EeeHCWFDCayFGpSKkeHxZe2JSHsQ+hJYAwepTm6i8Bo=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.04-fc40cd1/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-yzu0Ea5/X38RGyaFx0VR1O2aXzWs/XHopDyQzouFXP8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.04-fc40cd1/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-C2av4foh8XcXi+CYzFEz6jeFIR7sTjZFi1fk2s0I46I=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-09-04";

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
