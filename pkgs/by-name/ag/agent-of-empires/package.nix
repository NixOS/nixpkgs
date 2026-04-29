{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  buildNpmPackage,
  libgit2,
  openssl,
  zlib,
  stdenv,
  gitMinimal,
  nix-update-script,
}:

let
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "njbrake";
    repo = "agent-of-empires";
    tag = "v${version}";
    hash = "sha256-4jy3ooWASCQ44q4OenBWXs4gA0MAU+uD2BmaV4k9JO4=";
  };

  # Common Rust build arguments shared between the TUI-only and web-enabled variants.
  commonArgs = {
    inherit version src;
    cargoHash = "sha256-Ic0QncAIcWPMpfYAfEx3x8m41pZcbWyQJJ/2dVu/WMQ=";
    nativeBuildInputs = [
      pkg-config
      installShellFiles
    ];
    nativeCheckInputs = [ gitMinimal ];
    buildInputs = [
      libgit2
      openssl
      zlib
    ];
    env.OPENSSL_NO_VENDOR = 1;
    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd aoe \
        --bash <($out/bin/aoe completion bash) \
        --fish <($out/bin/aoe completion fish) \
        --zsh <($out/bin/aoe completion zsh)
    '';
  };

  # Build the React/Vite web dashboard as a standalone derivation.
  # AOE_WEB_DIST is read by build.rs to skip running npm during the Rust build.
  # Update npmDepsHash when web/package-lock.json changes:
  #   nix-update agent-of-empires (via passthru.npmDeps)
  webFrontend = buildNpmPackage {
    pname = "agent-of-empires-web";
    inherit version src;
    sourceRoot = "${src.name}/web";
    npmDepsHash = "sha256-xk+Tob7yptWVaorn86xVgVtTYz2h0moPJDMe1kXt1Bs=";
    installPhase = ''
      mkdir $out
      cp -r dist $out/
    '';
  };

  sharedMeta = {
    homepage = "https://github.com/njbrake/agent-of-empires";
    changelog = "https://github.com/njbrake/agent-of-empires/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gdw2 ];
    mainProgram = "aoe";
    platforms = lib.platforms.unix;
  };
in

rustPlatform.buildRustPackage (
  commonArgs
  // {
    pname = "agent-of-empires";
    __structuredAttrs = true;

    passthru = {
      updateScript = nix-update-script { };
      # Build variant with the web dashboard included (--features serve).
      # Use as: pkgs.agent-of-empires.withWeb
      withWeb = rustPlatform.buildRustPackage (
        commonArgs
        // {
          pname = "agent-of-empires-web";
          buildFeatures = [ "serve" ];
          env = commonArgs.env // {
            AOE_WEB_DIST = "${webFrontend}/dist";
          };
          # Expose npmDeps so nix-update can recompute npmDepsHash automatically.
          passthru.npmDeps = webFrontend.npmDeps;
          meta = sharedMeta // {
            description = "Terminal session manager for AI coding agents, built on tmux (with web dashboard)";
          };
        }
      );
    };

    meta = sharedMeta // {
      description = "Terminal session manager for AI coding agents, built on tmux";
      longDescription = ''
        Agent of Empires (AoE) is a terminal session manager for AI coding
        agents on Linux and macOS. Built on tmux, it allows running multiple
        AI agents in parallel across different branches of your codebase,
        each in its own isolated session with optional Docker sandboxing.

        Supports Claude Code, OpenCode, Mistral Vibe, Codex CLI, and Gemini CLI.
      '';
    };
  }
)
