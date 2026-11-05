{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  patchelf,
  installShellFiles,
  zlib,
  testers,
  incus-spawn,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  version = "0.4.2";
  pname = "incus-spawn";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenvNoCC.hostPlatform.system}");

  dontUnpack = true;
  dontBuild = true;
  dontStrip = stdenvNoCC.hostPlatform.isDarwin;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    # FIXME: drop patchelf override after patchelf 0.19.3 lands in stdenv.
    # patchelf 0.19.2 corrupts GraalVM native images by splitting LOAD
    # segments when expanding the INTERP section.
    # https://github.com/NixOS/nixpkgs/issues/577387
    (patchelf.overrideAttrs (
      finalAttrs: _: {
        version = "0.15.2";
        src = fetchurl {
          url = "https://github.com/NixOS/patchelf/releases/download/${finalAttrs.version}/patchelf-${finalAttrs.version}.tar.bz2";
          hash = "sha256-F3RfVkFZyOIo/EEtplogSLhGxLa0Igt3y/IkFuAvLXw=";
        };
      }
    ))
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/isx
    install -Dm755 ${finalAttrs.passthru.git-remote-isx} $out/bin/git-remote-isx
    install -Dm755 ${finalAttrs.passthru.isx-proxy.${stdenvNoCC.hostPlatform.system}} $out/bin/isx-proxy

    runHook postInstall
  '';

  # Generate shell completions after autoPatchelfHook has patched the ELF binary.
  # On Linux, autoPatchelfHook runs in postFixupHooks so we use installCheckPhase
  # which runs after fixup is fully complete. On Darwin no patching is needed but
  # we keep the same phase for consistency.
  doInstallCheck = stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    installShellCompletion --cmd isx \
      --bash <($out/bin/isx completion bash) \
      --zsh <($out/bin/isx completion zsh) \
      --fish <($out/bin/isx completion fish)

    runHook postInstallCheck
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/incus-spawn-linux-amd64";
        hash = "sha256-BEpVPnpneIAax/Q2MEuQB6A5Fkta9JWp4wE60a0FKMM=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/incus-spawn-linux-aarch64";
        hash = "sha256-tW1DlF8tcCSy8c0rXXIHXC555ihw64Qayva9RhXlmSQ=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/incus-spawn-macos-aarch64";
        hash = "sha256-QNV4GRjAJzrwFSnXnlgU90wqkFMYcRQyJwRgEN3Oj0I=";
      };
    };

    git-remote-isx = fetchurl {
      url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/git-remote-isx";
      hash = "sha256-I9zmdLzO7VcfLHdgFD2Lvwiq4fkDw885j1JWsL8c+hA=";
    };

    isx-proxy = {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/isx-proxy-linux-amd64";
        hash = "sha256-G5BCvPHzKJ7UOKyf7LTaZRYIjroQPa6CqYGRcr+O/i0=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/isx-proxy-linux-aarch64";
        hash = "sha256-HTl7WR7STFhtvwrxldfGVesgpkbTz1ecM8uqzSJvAVI=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/Sanne/incus-spawn/releases/download/v${finalAttrs.version}/isx-proxy-macos-aarch64";
        hash = "sha256-UQxX3v+89g9Q1d1qwGx35dv+M9jehdIPQCaE0mon2Q8=";
      };
    };

    tests.version = testers.testVersion {
      package = incus-spawn;
      command = "isx --version";
    };

    updateScript = writeShellScript "update-incus-spawn" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/Sanne/incus-spawn/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "incus-spawn is already at $NEW_VERSION"
          exit 0
      fi
      update-source-version incus-spawn "$NEW_VERSION" --source-key="git-remote-isx" --ignore-same-hash
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version incus-spawn "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
        update-source-version incus-spawn "$NEW_VERSION" --ignore-same-version --source-key="isx-proxy.$platform"
      done
    '';
  };

  meta = {
    description = "CLI tool for managing isolated Incus development environments";
    longDescription = ''
      incus-spawn (isx) creates isolated Linux development environments using
      Incus system containers with copy-on-write branching, a MITM TLS proxy
      for credential isolation, and an interactive TUI.
    '';
    homepage = "https://github.com/Sanne/incus-spawn";
    changelog = "https://github.com/Sanne/incus-spawn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames finalAttrs.passthru.sources;
    mainProgram = "isx";
    maintainers = with lib.maintainers; [
      galder
    ];
  };
})
