{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  libxcrypt-legacy,
  makeBinaryWrapper,
  pgsql-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgsql-tools";
  version = "2.1.0";

  src = fetchurl (
    let
      sources = {
        x86_64-linux = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-linux-x64.tar.gz";
          hash = "sha256-dN7+LJCUwb39ypuJV4p3jUHNGAPaObN4aZvsOHIpmkQ=";
        };
        aarch64-linux = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-linux-arm64.tar.gz";
          hash = "sha256-rD8jymGdM1RDGDbrKu6E7xoWtSMRNuc2ngCmR+sHgQI=";
        };
        x86_64-darwin = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-osx-x86.tar.gz";
          hash = "sha256-KLl7HPChurzB6QYV6AqAP3g1J3VKl61+we3opzJQwG0=";
        };
        aarch64-darwin = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-osx-arm64.tar.gz";
          hash = "sha256-tpabEKB1kqse7D58FsP/9jywk+vgAAvptL9MadwxWg8=";
        };
      };
    in
    sources.${stdenv.hostPlatform.system}
  );

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    libxcrypt-legacy
    (lib.getLib stdenv.cc.cc)
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/pgsql-tools
    install -Dm755 ossdbtoolsservice_main $out/lib/pgsql-tools/ossdbtoolsservice_main
    cp -r _internal $out/lib/pgsql-tools/

    makeBinaryWrapper $out/lib/pgsql-tools/ossdbtoolsservice_main $out/bin/ossdbtoolsservice_main \
      ${lib.optionalString stdenv.isLinux ''--prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxcrypt-legacy
          (lib.getLib stdenv.cc.cc)
        ]
      }"''} \
      --chdir $out/lib/pgsql-tools

    runHook postInstall
  '';

  doInstallCheck = true;

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/microsoft/pgsql-tools";
    description = "Backend service for PostgreSQL server tools, offering features such as connection management, query execution with result set handling, and language service support via the VS Code protocol";
    changelog = "https://github.com/microsoft/pgsql-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "ossdbtoolsservice_main";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
