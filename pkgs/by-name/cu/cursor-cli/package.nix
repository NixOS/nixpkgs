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
      url = "https://downloads.cursor.com/lab/2026.02.13-41ac335/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-mJPEmBNbmsTfgt0b7abrSHJLI52WfLny5Es4uGyDwew=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.02.13-41ac335/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-ncXdGxOYlwud4Z3w5DMOmXUZ2hEcI/q4stm0yACuvy4=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.02.13-41ac335/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-KcmGT6WCEc97qKqtZknFsUo9RX2SOuyjv6Jyfnrv3Os=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.02.13-41ac335/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-ib0ZsXVc2YqAkPuMie4kwWIFrmNcD+1vX3tcvyA/PJw=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-02-13";

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
