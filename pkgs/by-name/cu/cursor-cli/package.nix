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
      url = "https://downloads.cursor.com/lab/2025.10.02-bd871ac/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-tqppTOkeChlyw3IjSkhGpNvMX9U5s2hiu13/RWakENg=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.02-bd871ac/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-Gf/2wLS2+xQ6Mu4u96n4hI1I4L2iIG16R668BQCNZaw=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.02-bd871ac/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-/qznJxLpyUBH4L6zJSDB5mVFVk2Y7UJCt2Uw5g7U6AQ=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.10.02-bd871ac/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-drbaPM4ho5/1vmQWMgBelmqR7Np45w/XR0ZsfR53vZI=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-10-02";

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
