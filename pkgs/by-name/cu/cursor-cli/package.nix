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
      url = "https://downloads.cursor.com/lab/2026.05.24-dda726e/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-+hK1TIp6gLLboHlZQTOtA2qbnB58oKkPGlaGvg/UyYc=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.24-dda726e/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-Uo9Nma7S3yQft6ocKOVFBknKDYCQTZiPJPhEBehLObY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.24-dda726e/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-6X6jaZBW/deCyiL/KAjTqVCF0bGwlds4wmU3GkSpfmU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.24-dda726e/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-rwi0NjOmQB3S89H8y5KmF19vxbJtj8gv/p7susx45Q8=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-05-24";

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

    mkdir -p $out/bin $out/share/cursor-cli
    cp -r * $out/share/cursor-cli/
    ln -s $out/share/cursor-cli/agent $out/bin/agent

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
    mainProgram = "agent";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
