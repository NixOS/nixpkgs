{
  lib,
  astal,
  blueprint-compiler,
  buildGoModule,
  callPackage,
  dart-sass,
  symlinkJoin,
  fetchFromGitHub,
  fetchpatch2,
  gjs,
  glib,
  gobject-introspection,
  gtk4-layer-shell,
  installShellFiles,
  nix-update-script,
  nodejs,
  stdenv,
  wrapGAppsHook3,

  extraPackages ? [ ],
}:
buildGoModule rec {
  pname = "ags";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Aylur";
    repo = "ags";
    tag = "v${version}";
    hash = "sha256-snHhAgcH8hACWZFaAqHr5uXH412UrAuA603OK02MxN8=";
  };

  patches = [
    # refactor for better nix support
    (fetchpatch2 {
      url = "https://github.com/Aylur/ags/commit/17df94c576d0023185770f901186db427f2ec0a2.diff?full_index=1";
      hash = "sha256-tcoifkYmXjV+ZbeAFRHuk8cVmxWMrS64syvQMGGKAVA=";
    })
  ];

  vendorHash = "sha256-Pw6UNT5YkDVz4HcH7b5LfOg+K3ohrBGPGB9wYGAQ9F4=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.astalGjs=${astal.gjs}/share/astal/gjs"
    "-X main.gtk4LayerShell=${gtk4-layer-shell}/lib/libgtk4-layer-shell.so"
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    installShellFiles
  ];

  buildInputs = extraPackages ++ [
    glib
    astal.io
    astal.astal3
    astal.astal4
    gobject-introspection # needed for type generation
  ];

  preFixup =
    let
      # git files are usually in `dev` output.
      # `propagatedBuildInputs` are also available in the gjs runtime
      # so we also want to generate types for these.
      depsOf = pkg: [ (pkg.dev or pkg) ] ++ (map depsOf (pkg.propagatedBuildInputs or [ ]));
      girDirs = symlinkJoin {
        name = "gir-dirs";
        paths = lib.flatten (map depsOf buildInputs);
      };
    in
    ''
      gappsWrapperArgs+=(
        --prefix EXTRA_GIR_DIRS : "${girDirs}/share/gir-1.0"
        --prefix PATH : "${
          lib.makeBinPath (
            [
              gjs
              nodejs
              dart-sass
              blueprint-compiler
              astal.io
            ]
            ++ extraPackages
          )
        }"
      )
    '';

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)
      # bash
      ''
        installShellCompletion \
          --cmd ags \
          --bash <($out/bin/ags completion bash) \
          --fish <($out/bin/ags completion fish) \
          --zsh <($out/bin/ags completion zsh)
      '';

  passthru = {
    bundle = callPackage ./bundle.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scaffolding CLI for Astal widget system";
    homepage = "https://github.com/Aylur/ags";
    changelog = "https://github.com/Aylur/ags/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      foo-dogsquared
      johnrtitor
      perchun
    ];
    mainProgram = "ags";
    platforms = lib.platforms.linux;
  };
}
