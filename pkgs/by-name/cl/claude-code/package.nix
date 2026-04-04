{
  lib,
  stdenvNoCC,
  fetchurl,
  glibc,
  makeWrapper,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  bubblewrap,
  procps,
  socat,
}:
let
  version = "2.1.92";

  gcsBucket = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";

  # Per-platform download URLs and SRI hashes from the GCS manifest.
  # To update, see update.sh or the instructions in flake.nix.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      hash = "sha256-4iMkUUln/y1en5Hw7jfkZ1v4tt/sJ/r7GcslzFsj/K8=";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      hash = "sha256-CN6z1WR3SW65LmJPSS4lsSP0Un3VZ09xr/9YpI7M2VM=";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      hash = "sha256-1CK1zJdLO8Syj2mBRP0DFvPhd3S6vgvB63bCuwhY0Ko=";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      hash = "sha256-bRuWV3J9zoEzKzzaEb/gqMg+I5LjwGKjECLhCw5xzdE=";
    };
  };

  info =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenvNoCC.hostPlatform.system}");

  isLinux = stdenvNoCC.hostPlatform.isLinux;

  # The Nix store's dynamic linker for the current platform.
  # On NixOS, /lib64/ld-linux-x86-64.so.2 doesn't exist (unless nix-ld
  # is enabled), so we need to invoke the binary through the Nix store's
  # copy of the dynamic linker.
  #
  # We CANNOT use autoPatchelfHook to rewrite the binary's ELF interpreter
  # because this is a Bun Single Executable Application (SEA). Bun embeds
  # the application bytecode at a specific offset within the binary, and
  # autoPatchelfHook modifies the ELF layout, shifting those offsets and
  # breaking the embedded code detection — causing the binary to fall back
  # to behaving as plain Bun.
  interpreter = "${glibc}/lib/${
    if stdenvNoCC.hostPlatform.isx86_64 then "ld-linux-x86-64.so.2" else "ld-linux-aarch64.so.1"
  }";
in
stdenvNoCC.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "${gcsBucket}/${version}/${info.platform}/claude";
    hash = info.hash;
  };

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  # Install the unmodified binary to libexec (not bin) on Linux.
  # On macOS, Mach-O binaries use dyld from the OS — no patching needed.
  installPhase = ''
    runHook preInstall
    ${
      if isLinux then
        ''
          install -Dm755 $src $out/libexec/claude
        ''
      else
        ''
          install -Dm755 $src $out/bin/claude
        ''
    }
    runHook postInstall
  '';

  # https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview#environment-variables
  postFixup =
    if isLinux then
      ''
        # On Linux, create a wrapper that invokes the unmodified binary
        # through the Nix store's dynamic linker. The --library-path flag
        # tells the linker where to find glibc, and the binary path plus
        # "$@" (user args) are passed through.
        makeWrapper ${interpreter} $out/bin/claude \
          --add-flags "--library-path ${lib.makeLibraryPath [ glibc ]} $out/libexec/claude" \
          --set DISABLE_AUTOUPDATER 1 \
          --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
          --set DISABLE_INSTALLATION_CHECKS 1 \
          --unset DEV \
          --prefix PATH : ${
            lib.makeBinPath [
              procps
              bubblewrap
              socat
            ]
          }
      ''
    else
      ''
        wrapProgram $out/bin/claude \
          --set DISABLE_AUTOUPDATER 1 \
          --set-default FORCE_AUTOUPDATE_PLUGINS 1 \
          --set DISABLE_INSTALLATION_CHECKS 1 \
          --unset DEV \
          --prefix PATH : ${lib.makeBinPath [ procps ]}
      '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Agentic coding tool that lives in your terminal, understands your codebase, and helps you code faster";
    homepage = "https://github.com/anthropics/claude-code";
    license = lib.licenses.unfree;
    mainProgram = "claude";
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [
      # add your nixpkgs maintainer name here
    ];
  };
}
