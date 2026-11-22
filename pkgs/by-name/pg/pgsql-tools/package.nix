{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  cacert,
  libxcrypt-legacy,
  makeBinaryWrapper,
  openssl,
  pgsql-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgsql-tools";
  version = "3.7.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl (
    let
      sources = {
        x86_64-linux = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-linux-x64.tar.gz";
          hash = "sha256-VGJ6loN2PsbH2Nxvyy73Ewa7oejrOIUbdSGYBCEpUmA=";
        };
        aarch64-linux = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-linux-arm64.tar.gz";
          hash = "sha256-kpmjXYNVJ6QZahpACtLZOLi/DxJF6f66Sqo2Lu4CSlY=";
        };
        aarch64-darwin = {
          url = "https://github.com/microsoft/pgsql-tools/releases/download/v${finalAttrs.version}/pgsqltoolsservice-osx-arm64.tar.gz";
          hash = "sha256-7qo/cS043I9nXkfWmzMYpD9UY9ovFuqMeddb43RnG6o=";
        };
      };
    in
    sources.${stdenv.hostPlatform.system}
  );

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxcrypt-legacy
    (lib.getLib stdenv.cc.cc)
    openssl
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/pgsql-tools
    install -Dm755 ossdbtoolsservice_main $out/lib/pgsql-tools/ossdbtoolsservice_main
    cp -r _internal $out/lib/pgsql-tools/

    # nixpkgs CPython exports _PYTHON_SYSCONFIGDATA_NAME and _PYTHON_HOST_PLATFORM in any shell with python3
    makeBinaryWrapper $out/lib/pgsql-tools/ossdbtoolsservice_main $out/bin/ossdbtoolsservice_main \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''--prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxcrypt-legacy
          (lib.getLib stdenv.cc.cc)
        ]
      }"''} \
      --unset _PYTHON_SYSCONFIGDATA_NAME \
      --unset _PYTHON_HOST_PLATFORM \
      --chdir $out/lib/pgsql-tools

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    pushd $out/lib/pgsql-tools/_internal

    rm libssl.so.3 libcrypto.so.3

    for vendored in psycopg_binary.libs/libssl-*.so.3 psycopg_binary.libs/libcrypto-*.so.3; do
      name=$(basename "$vendored")
      for so in psycopg_binary.libs/*.so*; do
        if patchelf --print-needed "$so" | grep -qxF "$name"; then
          patchelf --replace-needed "$name" "''${name%%-*}.so.3" "$so"
        fi
      done
      rm "$vendored" "$name"
    done

    popd
  '';

  preFixup = ''
    rm $out/lib/pgsql-tools/_internal/certifi/cacert.pem
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt $out/lib/pgsql-tools/_internal/certifi/cacert.pem
  '';

  dontAutoPatchelf = true;

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    autoPatchelf $out/lib/pgsql-tools/_internal

    patchelf --page-size 2097152 \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $out/lib/pgsql-tools/_internal \
      $out/lib/pgsql-tools/ossdbtoolsservice_main
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "ossdbtoolsservice_main";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
