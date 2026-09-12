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
  pipewireSupport ? stdenv.hostPlatform.isLinux,
}:
let
  addonName =
    let
      inherit (stdenv.hostPlatform) node isx86_64;
      arch = if isx86_64 then "x64-baseline" else node.arch;
    in
    "pi_natives.${node.platform}-${arch}.node";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "omp";
  version = "18.1.17";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "can1357";
    repo = "oh-my-pi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Pm47xHRvEQoOvWYFNtJhgJkueAThfrLYhBysjQCQoQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-89/hqvbgMeJLKZdzP+ZnJRjSXs1NoDu8hAQIdlNlDQM=";
  };

  postPatch = ''
    substituteInPlace packages/coding-agent/src/cli.ts \
      --replace-fail 'if (Bun.semver.order(Bun.version, MIN_BUN_VERSION) < 0)' 'if (false)'
  '';

  # required until https://github.com/NixOS/nixpkgs/issues/255890 & https://github.com/NixOS/nixpkgs/issues/335534 are fixed
  node_modules = stdenv.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

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

    outputHash = "sha256-wqfKptBYo7GENPQLz3BfZ/m9i5lhng6yYjWbz7L6NNw=";
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
  ++ lib.optionals pipewireSupport [ pipewire ];

  dontStrip = true;

  env = {
    RUSTC_BOOTSTRAP = "1";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin { BUN_NO_CODESIGN_MACHO_BINARY = "1"; };

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/* .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    echo "Building pi-natives"
    cargo build --release -p pi-natives ${lib.optionalString pipewireSupport "--features wayland-pipewire"}
    install -Dm755 "target/release/libpi_natives${stdenv.hostPlatform.extensions.sharedLibrary}" \
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

    mkdir -p $out/lib/omp
    cp -R packages python node_modules $out/lib/omp/
    chmod -R u+w $out/lib/omp

    # Prune foreign binaries to eliminate dead code and prevent autoPatchelf issues
    find $out/lib/omp/node_modules -type d \( ${
      lib.concatStringsSep " -o " (
        lib.map (n: "-name '*${n}*'") (
          [
            "musl"
            "sunos"
            "win32"
            "aix"
            "openbsd"
            "freebsd"
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            "linux"
            "x64"
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            "darwin"
          ]
          ++ lib.optionals stdenv.hostPlatform.isx86_64 [
            "arm64"
          ]
        )
      )
    } \) -exec rm -rf {} +
    find $out/lib/omp/node_modules -type f -name '*.exe' -delete

    makeWrapper "${lib.getExe bun}" "$out/bin/omp" --add-flags "$out/lib/omp/packages/coding-agent/dist/cli.js"

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
      "node_modules"
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
      adamcstephens
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
