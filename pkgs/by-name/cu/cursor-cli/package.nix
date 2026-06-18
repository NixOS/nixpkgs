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
      url = "https://downloads.cursor.com/lab/2026.06.12-19-59-36-f6aba9a/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-bn8gLdiHW1adZ0VkvmN28Pb7X35F/dlztZuE8zzJoeQ=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.06.12-19-59-36-f6aba9a/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-otjrJCOKW+be5QmK+OJkYqJMbTZolVzSVfCsqNs1Otw=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.06.12-19-59-36-f6aba9a/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-kTyFA999IZRH3wnlL3kpBD/ch0d+HlkGC2GqrneJ37k=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.06.12-19-59-36-f6aba9a/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-fgM9Wuw693QhgmgLGbAzyR42ifUSUCaERTMZjPC1o+w=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "2026.06.12-19-59-36-f6aba9a";

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
