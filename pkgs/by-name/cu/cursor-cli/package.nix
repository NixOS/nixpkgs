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
      url = "https://downloads.cursor.com/lab/2026.01.28-fd13201/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-Nj6q11iaa++b5stsEu1eBRAYUFRPft84XcHuTCZL5D0=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.28-fd13201/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-6oajVZw599vzy2c1olEzoIlqbmfZRK1atb85fiR72y0=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.28-fd13201/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-G23LC7Sl1GjfaECndSuyCxHK4drkJKG3B1U2k5SAHJA=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.28-fd13201/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-R5kEfd84IaUXuN+PIzpGD1NGPzD6xxM9NAXAAt6d0N8=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-01-28";

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
