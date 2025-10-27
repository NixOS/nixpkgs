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
      url = "https://downloads.cursor.com/lab/2025.10.22-f894c20/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-bblnHWrPXJ9UmStfjUis1jLYLyawRchF0+UBMmPHy7M=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.22-f894c20/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-MnL1TLI7ggi9qaicUN//8o3EJoCPd0gF9KKfekIhUM0=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.22-f894c20/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-UEQyHEopNKf5uDUlZVzTESXVi8e2wHp83cD01diAISY=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.22-f894c20/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-18u5K/4Mc9+R32umaBWD5chgMoatkd/ZSMCiPElmPJU=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-10-22";

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
