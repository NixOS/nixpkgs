{
  lib,

  buildPythonApplication,
  pkgs,
  pytestCheckHook,
  python,
  setuptools,
  shtab,

  # Passed through from `./package.nix`.
  installShellFiles,
  lixPackageSets,
  mkShell,
  nix,
  nix-output-monitor,
  nixVersions,
  nixos-rebuild-ng,
  nixosTests,
  replaceVars,
  scdoc,

  # Override interface, required to be passed in from `./package.nix`.
  withNgSuffix,
  withNom,
  withReexec,
  withShellFiles,
  withTmpdir,
}:
let
  executable = if withNgSuffix then "nixos-rebuild-ng" else "nixos-rebuild";
  version = lib.trivial.release;

  # If we're using `nix-output-monitor`, make sure it's pinned to the right version of Nix.
  nix-output-monitor-pinned = nix-output-monitor.override {
    withPinnedNix = true;
    inherit nix;
  };

  maybeNom = if withNom then nix-output-monitor-pinned else nix;
  nix-or-nom = if withNom then "nom" else "nix";
in
buildPythonApplication {
  pname = "nixos-rebuild-ng";
  inherit version;

  src = ./src;

  pyproject = true;

  build-system = [ setuptools ];

  nativeBuildInputs = lib.optionals withShellFiles [
    installShellFiles
    shtab
    scdoc
  ];

  patches = [
    (replaceVars ./0001-replacements.patch {
      inherit executable version;

      # Make sure that we use the Nix package we depend on, not the ambient Nix in the PATH.
      # If we've requested to use `nom`, use that for `nix` and `nix-build` commands.
      #
      # This is important, because NixOS defaults the architecture of the rebuilt system to the
      # architecture of the nix-* binaries used. So if on an amd64 system the user has an i686 Nix
      # package in her PATH, then we would silently downgrade the whole system to be i686 NixOS on
      # the next reboot.
      nix = lib.getExe' nix "nix";
      nix-or-nom = lib.getExe' maybeNom "${nix-or-nom}";
      nix-build = lib.getExe' maybeNom "${nix-or-nom}-build";
      nix-channel = lib.getExe' nix "nix-channel";
      nix-copy-closure = lib.getExe' nix "nix-copy-closure";
      nix-env = lib.getExe' nix "nix-env";
      nix-instantiate = lib.getExe' nix "nix-instantiate";
      nix-store = lib.getExe' nix "nix-store";
    })
  ]
  ++ lib.optional withShellFiles ./0002-help-runs-man.patch;

  postInstall = lib.optionalString withShellFiles ''
    scdoc < ${./nixos-rebuild.8.scd} > ${executable}.8
    installManPage ${executable}.8

    installShellCompletion --cmd ${executable} \
      --bash <(shtab --shell bash nixos_rebuild.get_main_parser) \
      --zsh <(shtab --shell zsh nixos_rebuild.get_main_parser)
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "-vv" ];

  makeWrapperArgs =
    lib.optional (!withReexec) "--set NIXOS_REBUILD_REEXEC_ENV 1"
    ++ lib.optional (withTmpdir != null) "--set TMPDIR ${withTmpdir}";

  passthru =
    let
      python-with-pkgs = python.withPackages (
        ps: with ps; [
          mypy
          pytest
          # this is to help development (e.g.: better diffs) inside devShell
          # only, do not use its helpers like `mocker`
          pytest-mock
          ruff
        ]
      );
    in
    {
      devShell = mkShell {
        packages = [ python-with-pkgs ];
        shellHook = ''
          cd pkgs/by-name/ni/nixos-rebuild-ng/src || true
        '';
      };

      tests = {
        with_nom = nixos-rebuild-ng.override {
          withNom = true;
        };

        with_reexec = nixos-rebuild-ng.override {
          withReexec = true;
          withNgSuffix = false;
        };

        with_nix_latest = nixos-rebuild-ng.override {
          nix = nixVersions.latest;
        };

        with_nix_stable = nixos-rebuild-ng.override {
          nix = nixVersions.stable;
        };

        with_nix_2_28 = nixos-rebuild-ng.override {
          # oldest supported version in nixpkgs
          nix = nixVersions.nix_2_28;
        };

        with_lix_latest = nixos-rebuild-ng.override {
          nix = lixPackageSets.latest.lix;
        };

        with_lix_stable = nixos-rebuild-ng.override {
          nix = lixPackageSets.stable.lix;
        };

        inherit (nixosTests)
          # FIXME: this test is disabled since it times out in @ofborg
          # nixos-rebuild-install-bootloader-ng
          nixos-rebuild-specialisations-ng
          nixos-rebuild-target-host-ng
          ;

        repl = pkgs.callPackage ./tests/repl.nix { };

        # NOTE: this is a passthru test rather than a build-time test because we
        # want to keep the build closures small
        linters = pkgs.callPackage ./tests/linters.nix { };
      };
    };

  meta = {
    description = "Rebuild your NixOS configuration and switch to it, on local hosts and remote";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-rebuild-ng";
    license = lib.licenses.mit;
    maintainers = [ ];
    teams = [ lib.teams.nixos-rebuild ];
    mainProgram = executable;
  };
}
