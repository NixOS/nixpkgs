{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeBinaryWrapper,
  cacert,
}:
let
  sources = {
    x86_64-linux = {
      url = "https://dl.google.com/agy-extensions/releases/linux/agy-acp-server-1.2.1-linux-x86_64.zip";
      hash = "sha256-n78L1YSiZHgWH2N8q9dRE/clQchC0Uj1eO8aap7cuEM=";
    };
    aarch64-linux = {
      url = "https://dl.google.com/agy-extensions/releases/linux/agy-acp-server-1.2.1-linux-arm64.zip";
      hash = "sha256-fn70CIvBheGvQgQCng9OxCEK8gck8/8mIYasC86mqg4=";
    };
    aarch64-darwin = {
      url = "https://dl.google.com/agy-extensions/releases/macos/agy-acp-server-1.2.1-darwin-arm64.zip";
      hash = "sha256-D6uZOIEuazKztUPmXk86ACXO73VUE9sTVC2am4HqgDw=";
    };
  };

  srcInfo =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for antigravity-acp: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "antigravity-acp";
  version = "1.2.1"; # https://github.com/agentclientprotocol/registry/blob/main/antigravity-acp/agent.json

  src = fetchurl {
    inherit (srcInfo) url hash;
  };

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
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

    ln -s agy_acp_server.par $out/bin/agy_acp_server

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/agy_acp_server.par \
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
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
