{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  installShellFiles,
  versionCheckHook,
  autoPatchelfHook,
  zstd,
}:

# NOTE (aseipp): buck2 uses a precompiled binary build for good reason — the
# upstream codebase extensively uses unstable `rustc` nightly features, and as a
# result can't be built upstream in any sane manner. it is only ever tested and
# integrated against a single version of the compiler, which produces all usable
# binaries. you shouldn't try to workaround this or get clever and think you can
# patch it to work; just accept it for now. it is extremely unlikely buck2 will
# build with a stable compiler anytime soon; see related upstream issues:
#
#   - NixOS/nixpkgs#226677
#   - NixOS/nixpkgs#232471
#   - facebook/buck2#265
#   - facebook/buck2#322
#
# worth noting: it *is* possible to build buck2 from source using
# buildRustPackage, and it works fine, but only if you are using flakes and can
# import `rust-overlay` from somewhere else to vendor your compiler. See
# nixos/nixpkgs#226677 for more information about that.

# NOTE (aseipp): this expression is mostly automated, and you are STRONGLY
# RECOMMENDED to use to nix-update for updating this expression when new
# releases come out, which runs the sibling `update.sh` script.
#
# from the root of the nixpkgs git repository, run:
#
#    nix-shell maintainers/scripts/update.nix \
#      --argstr commit true \
#      --argstr package buck2

let

  # build hashes, which correspond to the hashes of the precompiled binaries
  # procued by GitHub Actions. this also includes the hash for a download of a
  # compatible buck2-prelude
  buildHashes = builtins.fromJSON (builtins.readFile ./hashes.json);
  archHashes = buildHashes.${stdenv.hostPlatform.system};

  # map our platform name to the rust toolchain suffix
  # NOTE (aseipp): must be synchronized with update.nu!
  platform-suffix =
    {
      x86_64-darwin = "x86_64-apple-darwin";
      aarch64-darwin = "aarch64-apple-darwin";
      x86_64-linux = "x86_64-unknown-linux-gnu";
      aarch64-linux = "aarch64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "buck2";
  version = "unstable-${buildHashes.version}"; # TODO (aseipp): kill 'unstable' once a non-prerelease is made

  srcs = [
    # the platform-specific binary — which is also
    # zstd-compressed
    (fetchurl {
      url = "https://github.com/facebook/buck2/releases/download/${lib.removePrefix "unstable-" finalAttrs.version}/buck2-${platform-suffix}.zst";
      hash = archHashes.buck2;
    })
    # rust-project, which is used to provide IDE integration Buck2 Rust projects,
    # is part of the official distribution
    (fetchurl {
      url = "https://github.com/facebook/buck2/releases/download/${lib.removePrefix "unstable-" finalAttrs.version}/rust-project-${platform-suffix}.zst";
      hash = archHashes.rust-project;
    })
  ];

  unpackCmd = "unzstd $curSrc -o $(stripHash $curSrc)";
  sourceRoot = ".";

  strictDeps = true;
  nativeBuildInputs = [
    installShellFiles
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    #225963
    stdenv.cc.cc.libgcc or null
  ];

  installPhase = ''
    runHook preInstall

    install -D buck2* "$out/bin/buck2"
    install -D rust-project* "$out/bin/rust-project"

    runHook postInstall
  '';

  # Have to put this at a weird stage because if it is put in
  # postInstall, preFixup, or postFixup, autoPatchelf wouldn't
  # have run yet
  preInstallCheck =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd buck2 \
        --bash <(${emulator} $out/bin/buck2 completion bash ) \
        --fish <(${emulator} $out/bin/buck2 completion fish ) \
        --zsh <(${emulator} $out/bin/buck2 completion zsh )
    '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # TODO: When --version returns a real output, remove this.
  # Currently it just spits out a hash
  preVersionCheck = "version=buck2";

  passthru = {
    # compatible version of buck2 prelude; this is exported via passthru.prelude
    # for downstream consumers to use when they need to automate any kind of
    # tooling
    prelude = fetchurl {
      url = "https://github.com/facebook/buck2-prelude/archive/${buildHashes.preludeGit}.tar.gz";
      hash = buildHashes.preludeFod;
    };

    updateScript = ./update.nu;
  };

  meta = {
    description = "Fast, hermetic, multi-language build system";
    homepage = "https://buck2.build";
    changelog = "https://github.com/facebook/buck2/releases/tag/${lib.removePrefix "unstable-" finalAttrs.version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "buck2";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      thoughtpolice
      lf-
      _9999years
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
