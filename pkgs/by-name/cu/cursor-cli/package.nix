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
      url = "https://downloads.cursor.com/lab/2025.09.18-39624ef/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-LbckJixgsrxCUKxy06Llfurd4h52fcQ8MTRfY3YUxHk=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.18-39624ef/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-9XvRwPnW6fezjAzsvxUINRppQIDwCq5nESpbYWojt5U=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.18-39624ef/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-7cW29+jLfcm+tx1EmIeI+FWZXO8L4UdArJ7wvmMSCoM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.18-39624ef/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-LxuEMzROif0LO1bjS203lB8QBaXnVdmHHN+I3UXl578=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-09-18";

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
