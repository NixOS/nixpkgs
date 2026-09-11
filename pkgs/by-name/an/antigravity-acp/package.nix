{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
}:
let
  sources = {
    x86_64-linux = {
      url = "https://dl.google.com/agy-extensions/releases/linux/agy-acp-server-agy_acp_server_1.1.1-linux-x86_64.zip";
      hash = "sha256-OPYtAbMt6wkHs9OacewwH9Njafb/0c8mLUrzhRd/ed8=";
    };
    aarch64-linux = {
      url = "https://dl.google.com/agy-extensions/releases/linux/agy-acp-server-agy_acp_server_1.1.1-linux-arm64.zip";
      hash = "sha256-7WnmSzCPyxI6tUvzJ3v5yw1lEGT4hepaqw/1IMcXU5g=";
    };
    aarch64-darwin = {
      url = "https://dl.google.com/agy-extensions/releases/macos/agy-acp-server-agy_acp_server_1.1.1-darwin-arm64.zip";
      hash = "sha256-/fqRVlLNt7qAhcyP/+0HLL4AklGqLJUaq92geowooYk=";
    };
  };

  srcInfo =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for antigravity-acp: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "antigravity-acp";
  version = "1.1.1"; # https://github.com/agentclientprotocol/registry/blob/main/antigravity-acp/agent.json

  src = fetchurl {
    inherit (srcInfo) url hash;
  };

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 agy_acp_server.par $out/bin/agy_acp_server.par
    install -m555 localharness_external $out/bin/localharness_external

    ln -s $out/bin/agy_acp_server.par $out/bin/agy_acp_server

    runHook postInstall
  '';

  meta = {
    description = "Google's AI coding agent. Official ACP server powered by Antigravity";
    homepage = "https://antigravity.google/docs/ide/extensions";
    license = lib.licenses.unfree;
    maintainers = [
      lib.maintainers.aliheidary1381
      lib.maintainers.johnrtitor
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "agy_acp_server";
  };
}
