{
  lib,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  bun,
  cargo-tauri,
  nodejs,
  pkg-config,
  wrapGAppsHook3,

  dbus,
  glib-networking,
  gtk3,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pigeon-mail";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kylescudder";
    repo = "pigeon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JO73EfMhpFoEDhd6JISrGnQ0tBpWw2qfr+6sdOeD/Sc=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-qEJ99j3hCyN9pn2fXaoFbV1isVVhWybnZlRciyORoY0=";

  nativeBuildInputs = [
    bun
    cargo-tauri.hook
    nodejs
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    glib-networking
    gtk3
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  postPatch = ''
    cp -R ${finalAttrs.passthru.nodeModules}/node_modules node_modules
    chmod -R u+w node_modules
    patchShebangs node_modules
  '';

  buildAndTestSubdir = "src-tauri";

  # The core crate's tests need a Secret Service session and a mail fixture;
  # upstream runs them in its own CI.
  doCheck = false;

  preFixup = ''
    # WebKitGTK's DMA-BUF renderer misbehaves on some GPU stacks.
    gappsWrapperArgs+=(--set-default WEBKIT_DISABLE_DMABUF_RENDERER 1)
  '';

  passthru = {
    # Bun cannot fetch inside the sandbox, so the dependencies are a
    # fixed-output derivation pinned by bun.lock. Refresh the hashes whenever
    # bun.lock changes (see tools/update-node-modules-hash.sh upstream).
    nodeModules = stdenvNoCC.mkDerivation {
      pname = "pigeon-node-modules";
      inherit (finalAttrs) version src;

      nativeBuildInputs = [ bun ];

      dontConfigure = true;
      dontFixup = true;

      buildPhase = ''
        runHook preBuild

        export HOME=$TMPDIR
        bun install --frozen-lockfile --ignore-scripts --no-progress \
          --os=linux \
          --cpu=${if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x64"}

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R node_modules $out/

        runHook postInstall
      '';

      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash =
        {
          x86_64-linux = "sha256-XHYBL7EugJDnme6phAGfhJK+crJfk8fYExOCnUz0Tjk=";
          aarch64-linux = "sha256-ZSRWnSDQEg8XQH2zVPHdxroy9dSzB+Swuh4jJdqocQY=";
        }
        .${stdenvNoCC.hostPlatform.system};
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern, local-first IMAP/SMTP email client";
    homepage = "https://github.com/kylescudder/pigeon";
    changelog = "https://github.com/kylescudder/pigeon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "pigeon";
    maintainers = with lib.maintainers; [ kylescudder ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
