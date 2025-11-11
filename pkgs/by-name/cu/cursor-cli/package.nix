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
      url = "https://downloads.cursor.com/lab/2025.11.06-8fe8a63/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-otTYUTmGqqXT4Jx+r1RlFjJD7FYU62QRl+y69eo/khs=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.11.06-8fe8a63/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-jPqgGdtjLg4qZWktz1/X1LI0+e6RYcCtuLw91k1Xofg=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.11.06-8fe8a63/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-UVR+iomdZzmPfj4o4N4FfUSCa9ttJre7Ipso5weIn1k=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2025.11.06-8fe8a63/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-t5s9TfLLA/VLCYNF+fsf9wgfk2W96eQSIbW/cdUKMuY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2025-11-06";

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
