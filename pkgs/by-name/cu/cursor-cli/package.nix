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
      url = "https://downloads.cursor.com/lab/2026.03.30-a5d3e17/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-4NS2EdsRHS2+dkdDhicb/z4duyzG3fUn+dXVgBss4qA=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.30-a5d3e17/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-dRBud1TlTcCoZ2naQ94D/FzUpEuS5lxvpowYbHtXgSU=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.30-a5d3e17/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-9z4nTSikG/WTksC0KvgK1m1gZqUjtNQ3sXOAJzikWEg=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.03.30-a5d3e17/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-+l5f/W38rJlbOzrmsBdad+PX6MuzHaQxvhIwdgEDKrQ=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-03-30";

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
