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
      url = "https://downloads.cursor.com/lab/2026.05.16-0338208/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-E2YeEnyAjbGXe1lpcpZnb/NBWNOoQYRkCfuokvkQsaI=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.16-0338208/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-WM3Ucu5ia9rlEgXtfNYea6B7ccgmpFJm/p4JpQje+Vs=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.16-0338208/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-0/CJxz14JgrCAwhbXeSHXYwnpvh4AnbjUHOUzNxxBJw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.16-0338208/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-xVwbcStx3UW89PBCE4zfAWNUSvs4NlneLPgY8yJDLag=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-05-16";

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
