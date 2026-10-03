{
  lib,
  stdenvNoCC,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  fetchurl,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs-slim_24,
  makeWrapper,
  versionCheckHook,
  autoPatchelfHook,
  installShellFiles,
  ncurses,
  libx11,
  libxi,
  libxkbcommon,
  gtk3,
  webkitgtk_4_1,
  libsoup_3,
  cairo,
  gdk-pixbuf,
  glib,
  wayland,
  dbus,
  xdotool,
  version ? "2026.9.2",
}:
let
  pnpm = pnpm_12.override { nodejs-slim = nodejs-slim_24; };

  # Downgrade xdotool locally to version 3: Copilot's bundled webview
  # needs libxdo.so.3, while nixpkgs' xdotool 4 provides libxdo.so.4.
  xdotoolCompat = xdotool.overrideAttrs {
    version = "3.20211022.1";
    src = fetchFromGitHub {
      owner = "jordansissel";
      repo = "xdotool";
      tag = "v3.20211022.1";
      hash = "sha256-XFiaiHHtUSNFw+xhUR29+2RUHOa+Eyj1HHfjCUjwd9k=";
    };
  };

  matrixCryptoFilename =
    {
      "x86_64-linux" =
        if stdenvNoCC.hostPlatform.isMusl then
          "matrix-sdk-crypto.linux-x64-musl.node"
        else
          "matrix-sdk-crypto.linux-x64-gnu.node";
      "aarch64-linux" =
        assert
          !stdenvNoCC.hostPlatform.isMusl || throw "openclaw: Matrix crypto does not support aarch64-musl";
        "matrix-sdk-crypto.linux-arm64-gnu.node";
      "x86_64-darwin" = "matrix-sdk-crypto.darwin-x64.node";
      "aarch64-darwin" = "matrix-sdk-crypto.darwin-arm64.node";
    }
    .${stdenvNoCC.hostPlatform.system};

  matrixCrypto = fetchurl {
    url = "https://github.com/matrix-org/matrix-rust-sdk-crypto-nodejs/releases/download/v0.6.6/${matrixCryptoFilename}";
    hash =
      {
        "matrix-sdk-crypto.linux-x64-gnu.node" = "sha256-rrIQKaxrspzQZJP2exmlp1s9A3Ghq0Uv5Z94JJNQ8Pc=";
        "matrix-sdk-crypto.linux-x64-musl.node" = "sha256-41fCtYgB5Il0zavQ+3bvLMeXLIRcQbtQGRoNbqA2O8o=";
        "matrix-sdk-crypto.linux-arm64-gnu.node" = "sha256-xDw0fzl4buny0Rta4wiNGCwagWNvK2jcIpf+Zxa+KJE=";
        "matrix-sdk-crypto.darwin-x64.node" = "sha256-SiKjUemIue0ekGILNHTldjJc5Sh/YjNRtrLpz68HjCw=";
        "matrix-sdk-crypto.darwin-arm64.node" = "sha256-mdx9kKqDDZttlrzaI1ic4Pty0Q+E7ER8nSQZN/7obZ8=";
      }
      .${matrixCryptoFilename};
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openclaw";
  version = version;

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "openclaw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VRY5aJDmctoblL9hPb//Y3H1+1zWoKa0sbApdHu4saY=";
  };

  pnpmDepsHash = "sha256-SshG3GKE5tvvcZzxxXdZSqArfEmKMjJb3HMoQ9PEhyA=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    prePnpmInstall = ''
      pnpm config set fetch-retries 5
      pnpm config set fetch-timeout 1200000
      pnpm config set network-concurrency 8
    '';
    fetcherVersion = 4;
    hash = finalAttrs.pnpmDepsHash;
  };

  pnpmInstallFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--libc=${if stdenvNoCC.hostPlatform.isMusl then "musl" else "glibc"}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    ncurses
    libx11
    libxi
    libxkbcommon
    gtk3
    webkitgtk_4_1
    libsoup_3
    cairo
    gdk-pixbuf
    glib
    wayland
    dbus
    xdotoolCompat
  ];

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs-slim_24
    makeWrapper
    installShellFiles
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  # Stripping the bundled Node SEA executable corrupts its embedded payload.
  stripExclude = [
    "lib/openclaw/node_modules/.pnpm/@github+copilot-*/node_modules/@github/copilot-*/copilot"
  ];

  # Koffi ships both libc variants in one platform package. Keep only the
  # host variant so autoPatchelf does not inspect an incompatible binary.
  buildPhase = ''
    runHook preBuild

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      koffiCpu=${if stdenvNoCC.hostPlatform.isAarch64 then "arm64" else "x64"}
      koffiLibcDir=${if stdenvNoCC.hostPlatform.isMusl then "linux" else "musl"}_$koffiCpu
      rm -rf node_modules/.pnpm/@koromix+koffi-linux-*@*/node_modules/@koromix/koffi-linux-*/$koffiLibcDir
    ''}

    for matrixCryptoDir in node_modules/.pnpm/@matrix-org+matrix-sdk-crypto-nodejs@0.6.6*/node_modules/@matrix-org/matrix-sdk-crypto-nodejs; do
      install -m644 ${matrixCrypto} "$matrixCryptoDir/${matrixCryptoFilename}"
      printf 0.6.6 > "$matrixCryptoDir/${matrixCryptoFilename}.version"
    done

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      autoPatchelf node_modules
    ''}

    pnpm install --offline --frozen-lockfile ${lib.escapeShellArgs finalAttrs.pnpmInstallFlags}
    OPENCLAW_TSDOWN_MAX_OLD_SPACE_MB=8192 pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    libdir=$out/lib/openclaw
    mkdir -p $libdir $out/bin

    cp --reflink=auto -r package.json dist node_modules packages $libdir/
    cp --reflink=auto -r docs skills patches extensions qa $libdir/
    mkdir -p $libdir/src
    cp --reflink=auto -r src/agents $libdir/src/

    rm -f $libdir/node_modules/.pnpm/node_modules/@openclaw/example-ai-chat \
      $libdir/node_modules/.pnpm/node_modules/clawdbot \
      $libdir/node_modules/.pnpm/node_modules/moltbot \
      $libdir/node_modules/.pnpm/node_modules/openclaw-control-ui

    # Remove broken symlinks created by pnpm workspace linking in extensions
    find $libdir/extensions -xtype l -delete
    # Remove symlinks pointing back to the build sandbox
    find $libdir/dist/extensions -type l -lname "$NIX_BUILD_TOP/*" -delete

    makeWrapper ${lib.getExe nodejs-slim_24} $out/bin/openclaw \
      --add-flags "$libdir/dist/index.js" \
      --set NODE_PATH "$libdir/node_modules"
    ln -s $out/bin/openclaw $out/bin/moltbot
    ln -s $out/bin/openclaw $out/bin/clawdbot

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenvNoCC.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd openclaw \
        --bash <(${emulator} $out/bin/openclaw completion --shell bash) \
        --fish <(${emulator} $out/bin/openclaw completion --shell fish) \
        --zsh  <(${emulator} $out/bin/openclaw completion --shell zsh)
    ''
  );

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Self-hosted, open-source AI assistant/agent";
    longDescription = ''
      Self-hosted AI assistant/agent connected to all your apps on your Linux
      or macOS machine and controlled via your choice of chat app.

      Note: Project is in early/rapid development and uses LLMs to parse untrusted
      content while having full access to system by default.

      Parsing untrusted input with LLMs leaves them vulnerable to prompt injection.

      (Originally known as Moltbot and ClawdBot)
    '';
    homepage = "https://openclaw.ai";
    changelog = "https://github.com/openclaw/openclaw/releases/tag/${finalAttrs.src.tag}";
    # This output bundles the separately licensed Claude SDK/runtime
    # alongside OpenClaw's MIT-licensed code.
    # It also bundles the separately licensed GitHub Copilot CLI/runtime.
    license = with lib.licenses; [
      mit
      unfree
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    mainProgram = "openclaw";
    maintainers = with lib.maintainers; [
      chrisportela
      mkg20001
      nikhilmaddirala
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    knownVulnerabilities = [
      "Project uses LLMs to parse untrusted content, making it vulnerable to prompt injection, while having full access to system by default."
    ];
  };
})
