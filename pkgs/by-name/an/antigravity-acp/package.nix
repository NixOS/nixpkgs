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
  sources = lib.importJSON ./sources.json;

  srcInfo =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform for antigravity-acp: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "antigravity-acp";
  inherit (sources) version;

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

  passthru.updateScript = [
    ./update.sh
    (builtins.toString ./.)
  ];

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
