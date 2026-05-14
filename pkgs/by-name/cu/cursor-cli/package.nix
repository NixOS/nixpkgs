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
      url = "https://downloads.cursor.com/lab/2026.05.07-42ddaca/linux/x64/agent-cli-package.tar.gz";
      hash = "sha256-BTYNvK4UGWL8skJDjFkyBsEjvoUxaxHAlEKtr7gsyhs=";
    };
    aarch64-linux = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.07-42ddaca/linux/arm64/agent-cli-package.tar.gz";
      hash = "sha256-C+JfqTdhDGTxz3rUWH0a+TdUvQq26wAPQ1qN/U2C/0o=";
    };
    x86_64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.07-42ddaca/darwin/x64/agent-cli-package.tar.gz";
      hash = "sha256-TI74gxQ1VgrSmMvUXXwTQv6ixlALnarYul9DRrU2Arc=";
    };
    aarch64-darwin = fetchurl {
      url = "https://downloads.cursor.com/lab/2026.05.07-42ddaca/darwin/arm64/agent-cli-package.tar.gz";
      hash = "sha256-b1WL8URL+xtVjxOtJI1W3gAWh3i3cIN98f3aeDX5JlM=";
    };
  };
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  version = "0-unstable-2026-05-07";

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
