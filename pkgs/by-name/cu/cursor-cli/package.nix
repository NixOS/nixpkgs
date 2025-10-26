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
      url = "https://downloads.cursor.com/lab/2025.10.20-f1b214f/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-v6wGVuKrK4JFFaJN55le5+wZV7LI9Bc70Osc05F0PeQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.20-f1b214f/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-j3z3K2tt2wl54OjLMPudGnCP2+9U2dOspM0G0Ob68Ds=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.20-f1b214f/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-KRECUSqYohrCiF3YySZeJ0MaRhb7h+O+KyqCfpCbV8w=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.20-f1b214f/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-4S1HMPielrUwP5pyA/tp1FuByge9dcRx2XndTFnBKbY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-10-20";

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
