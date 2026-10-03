{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  libGL,
  vulkan-loader,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "neoscad";
  version = "0.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "neoscad";
    repo = "neoscad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R5rnz+PvIF207r7sxYzwhtp8OaZWQW232O4BqlnMQto=";
  };

  cargoHash = "sha256-oZL36e791HIqm67A0MUm/mkNMBGnN3qFZV7KXtmWCNs=";

  # Only the command-line tool: the workspace also holds the macOS app's
  # core, the WebAssembly builds and the conformance harness, none of which
  # a Nix user runs. The fonts and MCAD are compiled into the binary (the
  # default `bundled-assets` feature), so nothing else is installed.
  cargoBuildFlags = [
    "--package"
    "neoscad-cli"
  ];

  # Every workspace crate the CLI is built from. Tests that need the
  # OpenSCAD reference checkout, or a GPU to draw with (the build sandbox
  # has none), skip themselves when it is missing; checkFlags lists the
  # platform checks the nixpkgs build cannot meet.
  cargoTestFlags = [
    "--package"
    "neoscad-cli"
    "--package"
    "neoscad-lang"
    "--package"
    "neoscad-eval"
    "--package"
    "neoscad-geom"
    "--package"
    "neoscad-io"
    "--package"
    "neoscad-text"
    "--package"
    "neoscad-session"
    "--package"
    "neoscad-lsp"
    "--package"
    "neoscad-fmt"
    "--package"
    "neoscad-assets"
    "--package"
    "neoscad-render"
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Checks that the Metal frameworks are delay-initialized, which the
    # CLI's build script only arranges for a deployment target of macOS 15
    # or later (crates/cli/build.rs); nixpkgs builds for an older one.
    "--skip=gpu_frameworks_are_not_initialized_at_launch"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # The man page and completions come from the binary itself (`neoscad
  # generate`, from the same clap definitions that parse the command line),
  # so they need a binary that runs on the build machine: a cross build
  # goes without them rather than failing.
  postInstall = ''
    install -Dm644 -t $out/share/doc/neoscad LICENSE NOTICE
    install -Dm644 -t $out/share/doc/neoscad/licenses packaging/licenses/*
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/neoscad generate man > neoscad.1
    installManPage neoscad.1
    installShellCompletion --cmd neoscad \
      --bash <($out/bin/neoscad generate completions bash) \
      --fish <($out/bin/neoscad generate completions fish) \
      --zsh <($out/bin/neoscad generate completions zsh)
  '';

  # PNG export draws through wgpu, which loads the Vulkan loader and
  # libGL/EGL with dlopen at run time rather than linking them, so nothing
  # puts them on the RPATH by itself. Adding them there (as
  # alacritty and zed-editor do) rather than wrapping the binary keeps
  # LD_LIBRARY_PATH out of the environment of everything neoscad starts.
  # The drivers themselves come from /run/opengl-driver on NixOS.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        libGL
        vulkan-loader
      ]
    } $out/bin/neoscad
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenSCAD-compatible programmable solid CAD";
    longDescription = ''
      NeoSCAD is a new implementation of the OpenSCAD language, written in
      Rust. It runs .scad files and libraries as they are, takes
      OpenSCAD's command-line flags and renders with Manifold. It adds
      structured JSON output, check, measure and snapshot commands, an MCP
      server, a language server and a long-running serve mode.
    '';
    homepage = "https://neoscad.org";
    changelog = "https://github.com/neoscad/neoscad/releases/tag/v${finalAttrs.version}";
    # NeoSCAD itself is GPL-2.0-or-later; the binary also contains
    # manifold-rust (Apache-2.0), clipper2-rust (BSL-1.0), the Liberation
    # fonts (OFL-1.1), MCAD (LGPL-2.1) and a port of libtess2 (SGI-B-2.0).
    # NOTICE explains why the combined binary is distributed under
    # GPL-3.0-or-later terms.
    license = with lib.licenses; [
      gpl2Plus
      asl20
      boost
      ofl
      lgpl21Only
      sgi-b-20
    ];
    maintainers = with lib.maintainers; [ mattrobmattrob ];
    mainProgram = "neoscad";
    platforms = lib.platforms.unix;
  };
})
