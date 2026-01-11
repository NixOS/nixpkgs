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
      url = "https://downloads.cursor.com/lab/2026.01.02-80e4d9b/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-xQml5yMZ2cjBvG2J8mH5Ai65ZArt3kOkstwS245RP1k=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.02-80e4d9b/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-PpI3CgFi5hWZyKKRybolm8UZnPf3qAEH7+MqPkwsFUo=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.02-80e4d9b/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-F5DwlZYK79ZNSZS9BhTMD6ryUbbkLHqaDnwhQtmtLKc=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.02-80e4d9b/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-By3afWNXURIcmaZjFk9f0Aw0Z54S3zrgeYwzX0lTBD0=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-01-02";

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
