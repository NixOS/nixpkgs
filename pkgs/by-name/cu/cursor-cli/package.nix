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
      url = "https://downloads.cursor.com/lab/2025.08.27-24c29c1/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-046NAHLckWOvIG5WJ8p3SNiUTbelEw2eTZ+/1DvTpNY=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.27-24c29c1/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-Ft/7AivBm3VWsgtYAE0a9SqDLzuiFnGUTdEjsBZjUDA=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.27-24c29c1/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-lgn7gaiItLzvhh7ePtUcDCqPuZFUWE3WDSzn5TY3Taw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.27-24c29c1/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-+zC4rTzTCj1MSCYA///6Br82SffTRdICHuhnhaXsAWg=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-08-27";

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
