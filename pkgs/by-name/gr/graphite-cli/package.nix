{
  lib,
  stdenv,
  fetchurl,
  buildFHSEnv,
  git,
  installShellFiles,
  testers,
  graphite-cli,
}:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  suffix = selectSystem {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };

  version = "1.8.6";

  meta = {
    changelog = "https://graphite.dev/docs/cli-changelog";
    description = "CLI that makes creating stacked git changes fast & intuitive";
    downloadPage = "https://www.npmjs.com/package/@withgraphite/graphite-cli";
    homepage = "https://graphite.dev/docs/graphite-cli";
    license = lib.licenses.unfree; # no license specified
    mainProgram = "gt";
    maintainers = with lib.maintainers; [ joshheinrichs-shopify ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = graphite-cli;
      command = "gt --version";
    };
  };

  shellCompletions = ''
    installShellCompletion --cmd gt \
      --bash <($out/bin/gt completion) \
      --zsh <(ZSH_NAME=zsh $out/bin/gt completion) \
      --fish <($out/bin/gt fish)
  '';

  unwrapped = stdenv.mkDerivation {
    pname = "graphite-cli-unwrapped";
    inherit version meta passthru;
    strictDeps = true;

    src = fetchurl {
      url = "https://registry.npmjs.org/@withgraphite/graphite-cli-${suffix}/-/graphite-cli-${suffix}-${version}.tgz";
      hash = selectSystem {
        x86_64-linux = "sha256-YnG3iw35ZEyGbB9vGdcnj0qkvUfyLuaIEB5l09hkRck=";
        aarch64-linux = "sha256-Z4yY26hXf8++TX5tJcqufsAULTn9oUL90d9tDZj5d/k=";
        x86_64-darwin = "sha256-oV0tanuk2dzB62uChni9CJtSw3eFECQi3aMBc+ZV7Do=";
        aarch64-darwin = "sha256-6eogi8fMOD5IgRyEdPRxdDa17WytB1JwTpKRzyyhQ2Q=";
      };
    };

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
      git
      installShellFiles
    ];

    dontConfigure = true;
    dontBuild = true;
    # On Linux the binary is wrapped with buildFHSEnv; completions are
    # generated there. Here we only need to skip fixup to avoid patchelf/strip.
    dontFixup = stdenv.hostPlatform.isLinux;

    installPhase = ''
      runHook preInstall
      install -Dm755 bin/gt $out/bin/gt
      runHook postInstall
    '';

    postInstall = lib.optionalString stdenv.hostPlatform.isDarwin shellCompletions;
  };
in
# The binary is built with vercel/pkg, which appends a virtual filesystem to
# the executable at fixed byte offsets. patchelf and strip shift those offsets,
# corrupting the embedded data, so the binary must remain completely unmodified.
# On Linux we use buildFHSEnv to provide /lib64/ld-linux-*.so.* and shared
# libraries without touching the binary. On Darwin this isn't needed.
if stdenv.hostPlatform.isLinux then
  (buildFHSEnv {
    pname = "graphite-cli";
    inherit version passthru;

    targetPkgs = pkgs: [
      unwrapped
      pkgs.stdenv.cc.cc.lib
      git
    ];

    runScript = "gt";

    extraInstallCommands = ''
      ln -s $out/bin/graphite-cli $out/bin/gt
      source ${installShellFiles}/nix-support/setup-hook
      ${shellCompletions}
    '';

    meta = meta // {
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  }).overrideAttrs
    { strictDeps = true; }
else
  unwrapped
