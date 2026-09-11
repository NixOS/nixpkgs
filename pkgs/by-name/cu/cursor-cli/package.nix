{
  lib,
  fetchurl,
  stdenv,
  autoPatchelfHook,
  zlib,
}:

let
  inherit (stdenv) hostPlatform;
  sources = {
    x86_64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.08.31-4057e58/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-fjBttXUCGamcAO1Rf+iyNdPFTkyl934v8WDMl85wd5g=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.08.31-4057e58/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-z122tQR7MoDYpJRxz9Qb6x1eR1d0F3313yhRhXq2UUo=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.08.31-4057e58/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-qUSDz1oWB7/hLLNCFr4Mj5WJnw9pj7heUAuijXMy+7A=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-08-31";

  src = sources.${hostPlatform.system};

  buildInputs = lib.optionals hostPlatform.isLinux [
    zlib
  ];

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
