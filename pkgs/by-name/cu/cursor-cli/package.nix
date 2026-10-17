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
      url = "https://downloads.cursor.com/lab/2026.10.14-941492e/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-b2vzndLfKdzThkPN+rAVXOcWmZU4ifcy3uwSP2Viuy0=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.10.14-941492e/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-y7pA2Q1/aZh04TOlwVvzhUzuAGVlvTuwCmx5tJ1isNA=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.10.14-941492e/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-xtni6qGx4kIhUX4LQgax8Vk3kubw2KUum1B7vnqwzHc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-10-14";

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
