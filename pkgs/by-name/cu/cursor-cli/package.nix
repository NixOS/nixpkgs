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
      url = "https://downloads.cursor.com/lab/2026.08.11-e8db854/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-v/9L9vTp3TDB0O8KcLYHewdAFd0pSOTFBoXVOv3Pzlo=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.08.11-e8db854/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-6hP5LilfUjqZzo2PV9aJTSHl0eLQMP+tcYzNWVXKLu0=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.08.11-e8db854/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-RgRNbXvL17SaDPHNAapMp5qqLqXyx6MpZfwOvimEF5A=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-08-11";

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
