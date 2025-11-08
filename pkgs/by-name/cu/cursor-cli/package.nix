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
      url = "https://downloads.cursor.com/lab/2025.10.28-0a91dc2/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-mZ0T7rrKzwvaNUbrHBy3XO04vZSO6RQ4RmJmrdfaoJA=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.28-0a91dc2/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-bchHYPQ0O/0YWiPdj3wnq43p/fKFoP4KXpeSVWpLYpE=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.28-0a91dc2/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-PWx5QAs84gWNOHYZL20uFnW+m4rApRT6g4LtabjL+lw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.28-0a91dc2/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-VW76Lx2VKspiGkphp74ib4+F5FCdu8793f+xvD67OpM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-10-28";

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
