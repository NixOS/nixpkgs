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
      url = "https://downloads.cursor.com/lab/2025.12.17-996666f/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-dJ45VoAsSrfTCt3GdS/t9gfT5yie+TjJdNGd2ZrQEAI=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.12.17-996666f/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-orJS8JmQ0nOhhgU8Slz5hAJ381l9VmMVsmH2Lp3oTec=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.12.17-996666f/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-3f42EdqyjBMVxOqNhdHtmTwRqhW2/GUnmA6PBurXPNg=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.12.17-996666f/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-+loTRjtY7x5UYDKK98+RGRFn3cfp5FmHlGFep8p7ijs=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-12-17";

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
