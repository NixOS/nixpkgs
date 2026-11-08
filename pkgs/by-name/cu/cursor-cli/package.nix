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
      url = "https://downloads.cursor.com/lab/2026.11.05-86047df/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-Fwt3eGy/TJMGTWT/8StxoXi5aHMFYcZK/C6OdSU1RC4=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.11.05-86047df/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-ExVUv9v2g9jr/vg6K7RqxOXQYPGYcRBAsH7QY8JHGHE=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.11.05-86047df/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-Z4R+R+Pr0ytkw/tObzbUdfGXG3bgM7DtbJ4Bo8G0QNc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-11-05";

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
