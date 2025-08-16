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
      url = "https://downloads.cursor.com/lab/2025.08.09-d8191f3/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-sLI6D0A9GBqIJkC4i83Z9nBwk5TMQTclK1Hnkg+h8ds=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.09-d8191f3/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-6ei07gyIHgikbKFvtAF7sRQ2/f/2slJdkuMOAlvIDPA=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.09-d8191f3/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-zuhYmRAb2v7BUko8dX+i8kxV7C5E88G/IQNX72PWHdI=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.09-d8191f3/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-vz3i8QXJpeHRJ3bZHh0wWK/CCsNXFsk2p08pzkzyPyg=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-08-09";

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
