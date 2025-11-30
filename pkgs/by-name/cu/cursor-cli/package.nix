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
      url = "https://downloads.cursor.com/lab/2025.11.25-d5b3271/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-oWYGMIlp7d0cpS7iQxbj62XdfhXnztTqlu1yFmhVKVU=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.11.25-d5b3271/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-Cqoc+42LbrKTQv1YEQeX8Vfoj7KosUOWsdVTf6whxw4=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.11.25-d5b3271/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-PRxUE0AhEe/5EpXahWx5WW68uUkncwHGxG5eTjFxwyk=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.11.25-d5b3271/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-IOb37qUv9R/ZfH5ooThZmFbWxl592Zv8F7bAifsWvjk=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-11-25";

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
