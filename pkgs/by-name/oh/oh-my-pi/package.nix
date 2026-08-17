{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  cargo,
  rustc,
  cmake,
  ninja,
  pkg-config,
  rustPlatform,
  autoPatchelfHook,
  chromium,
  installShellFiles,
  makeWrapper,
  libopus,
  alsa-lib,
  libpulseaudio,
  pipewire,
  darwin,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
  withPuppeteer ? false,
  withWaylandScreencast ? false,
}:
let
  addonName =
    let
      inherit (stdenv.hostPlatform) node isx86_64;
      arch = if isx86_64 then "x64-baseline" else node.arch;
    in
    "pi_natives.${node.platform}-${arch}.node";

  nativeLibrary = "libpi_natives${stdenv.hostPlatform.extensions.sharedLibrary}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "oh-my-pi";
  version = "17.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GvzeVpyAfQ7Vh5Bd5eOCv5FOzmfHACfZZS7Xh+dF/lQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-LzBuO6T13J7oG4mvsOG2faBIkbN7b636iaLrUuLDDvA=";
  };

  postPatch = ''
    substituteInPlace packages/coding-agent/src/cli.ts \
      --replace-fail 'if (Bun.semver.order(Bun.version, MIN_BUN_VERSION) < 0)' 'if (false)'
  '';

  # required until https://github.com/NixOS/nixpkgs/issues/255890 & https://github.com/NixOS/nixpkgs/issues/335534 are fixed
  passthru.node_modules = stdenv.mkDerivation {
    pname = "oh-my-pi-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # Prevents breaking symlinks in node_modules
    dontFixup = true;

    outputHash = "sha256-MQzVxwhWIxvEd4X/KcB/oYILrSvnYB4wjjetgJxspSA=";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    bun
    cargo
    cmake
    installShellFiles
    makeWrapper
    ninja
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];

  buildInputs = [
    libopus
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ]
  ++ lib.optionals withWaylandScreencast [ pipewire ];

  dontStrip = true;

  env = {
    RUSTC_BOOTSTRAP = "1";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin { BUN_NO_CODESIGN_MACHO_BINARY = "1"; };

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/* .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building pi-natives"
    cargo build --release -p pi-natives ${lib.optionalString withWaylandScreencast "--features wayland-pipewire"}
    install -Dm755 "target/release/${nativeLibrary}" \
      "packages/natives/native/${addonName}"

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      autoPatchelf -- "packages/natives/native/${addonName}"
      patchelf --add-rpath "${
        lib.makeLibraryPath [
          libpulseaudio
          alsa-lib
        ]
      }" \
        "packages/natives/native/${addonName}"
    ''}
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      signIfRequired "packages/natives/native/${addonName}"
    ''}

    echo "Building JS bundle"
    bun --cwd="$PWD/packages/coding-agent" run prepack

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/oh-my-pi
    cp -R packages python node_modules $out/lib/oh-my-pi/

    makeWrapper "${lib.getExe bun}" "$out/bin/omp" \
      --add-flags "$out/lib/oh-my-pi/packages/coding-agent/dist/cli.js" \
      ${lib.optionalString withPuppeteer ''
        --set PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true \
        --set PUPPETEER_EXECUTABLE_PATH "${lib.getExe chromium}"
      ''}

    mkdir -p "$out/nix-support"
    ${
      if stdenv.hostPlatform.isLinux then
        ''
          patchelf --print-rpath "packages/natives/native/${addonName}" \
            > "$out/nix-support/embedded-addon-runpath"
        ''
      else
        ''
          echo "${lib.getLib libopus}/lib" > "$out/nix-support/embedded-addon-runpath"
        ''
    }

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd omp \
      ${lib.concatMapStringsSep " " (sh: "--${sh} <($out/bin/omp completions ${sh})") [
        "bash"
        "zsh"
        "fish"
      ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "passthru.node_modules"
    ];
  };

  meta = {
    description = "Terminal-based coding agent with multi-model support";
    homepage = "https://omp.sh";
    changelog = "https://github.com/can1357/oh-my-pi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "omp";
    maintainers = with lib.maintainers; [
      malix
      naxdy
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
