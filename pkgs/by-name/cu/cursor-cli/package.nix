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
      url = "https://downloads.cursor.com/lab/2025.08.22-82fb571/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-jfjYWM9Vuq9sYZcnqiap3TKuVWHHKt/aF7XaVilJjsE=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.22-82fb571/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-uMK5jO77TQntsrR450WWBj9q5VBowNUhO6UkZ/z1ys4=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.22-82fb571/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-gFM+igXGdLLJXVHAou6pRTIVqsg6iPagaghBAzRcPXw=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.08.22-82fb571/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-XN2QaFt/lbVHfFfdZaznRvUlMWIHq7nUbe3uptrGjN0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-08-22";

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
