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
      url = "https://downloads.cursor.com/lab/2026.01.17-d239e66/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-gZPjmxJxppni1tBL+4KNzP7It8vN0qG0e+xG42Cu/tM=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.17-d239e66/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-+ZTHbrRzte79MPrgCBb+Yj8GZaPCcDjc0v9vLI8wmoI=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.17-d239e66/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-6LNXzVh7hpAFZWCZUECJKIv9RzuWih3G/+9cFjof2zM=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.01.17-d239e66/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-mUjH/9ADFgsCdCvUmSUMbepJUHA/4bz7I01c51tlAM8=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-01-17";

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
