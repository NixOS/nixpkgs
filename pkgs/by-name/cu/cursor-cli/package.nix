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
      url = "https://downloads.cursor.com/lab/2026.02.27-e7d2ef6/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-QdNrUbDdA6dBUXa7iqumKsxrK4boySCWxCJ3FR9csqw=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.02.27-e7d2ef6/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-sG+kYYcXlbXMKaJIG4C6rqRECph31Ol6ah2gCxj1gaE=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.02.27-e7d2ef6/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-0GvOg1y7O27PFdwz+QDhMnNeDWbFFzmbk3me1oHsJJ4=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.02.27-e7d2ef6/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-IZEE+ckKRTDi3sDLqKqJkmyM3UH9FH0trRBcfSqAVeg=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-02-27";

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
