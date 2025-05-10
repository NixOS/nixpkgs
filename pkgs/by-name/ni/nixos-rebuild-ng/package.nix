{
  lib,
  stdenv,
  callPackage,
  installShellFiles,
  mkShell,
  nix,
  nixosTests,
  python3,
  python3Packages,
  runCommand,
  scdoc,
  withNgSuffix ? true,
  withReexec ? false,
  withShellFiles ? true,
  # Very long tmp dirs lead to "too long for Unix domain socket"
  # SSH ControlPath errors. Especially macOS sets long TMPDIR paths.
  withTmpdir ? if stdenv.hostPlatform.isDarwin then "/tmp" else null,
}:
let
  executable = if withNgSuffix then "nixos-rebuild-ng" else "nixos-rebuild";
  # This version is kind of arbitrary, we use some features that were
  # implemented in newer versions of Nix, but not necessary 2.18.
  # However, Lix is a fork of Nix 2.18, so this looks like a good version
  # to cut specific functionality.
  withNix218 = lib.versionAtLeast nix.version "2.18";
in
python3Packages.buildPythonApplication rec {
  pname = "nixos-rebuild-ng";
  version = "0.0.0";
  src = ./src;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = lib.optionals withShellFiles [
    installShellFiles
    python3Packages.shtab
    scdoc
  ];

  propagatedBuildInputs = [
    # Make sure that we use the Nix package we depend on, not something
    # else from the PATH for nix-{env,instantiate,build}. This is
    # important, because NixOS defaults the architecture of the rebuilt
    # system to the architecture of the nix-* binaries used. So if on an
    # amd64 system the user has an i686 Nix package in her PATH, then we
    # would silently downgrade the whole system to be i686 NixOS on the
    # next reboot.
    # The binary will be included in the wrapper for Python.
    (lib.getBin nix)
  ];

  postPatch = ''
    substituteInPlace nixos_rebuild/constants.py \
      --subst-var-by executable ${executable} \
      --subst-var-by withNix218 ${lib.boolToString withNix218} \
      --subst-var-by withReexec ${lib.boolToString withReexec} \
      --subst-var-by withShellFiles ${lib.boolToString withShellFiles}

    substituteInPlace pyproject.toml \
      --replace-fail nixos-rebuild ${executable}
  '';

  postInstall = lib.optionalString withShellFiles ''
    scdoc < ${./nixos-rebuild.8.scd} > ${executable}.8
    installManPage ${executable}.8

    installShellCompletion --cmd ${executable} \
      --bash <(shtab --shell bash nixos_rebuild.get_main_parser) \
      --zsh <(shtab --shell zsh nixos_rebuild.get_main_parser)
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "-vv" ];

  makeWrapperArgs = lib.optionals (withTmpdir != null) [
    "--set TMPDIR ${withTmpdir}"
  ];

  passthru =
    let
      python-with-pkgs = python3.withPackages (
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
        inherit (nixosTests)
          nixos-rebuild-install-bootloader-ng
          nixos-rebuild-specialisations-ng
          nixos-rebuild-target-host-ng
          ;
        repl = callPackage ./tests/repl.nix { };
        # NOTE: this is a passthru test rather than a build-time test because we
        # want to keep the build closures small
        linters = runCommand "${pname}-linters" { nativeBuildInputs = [ python-with-pkgs ]; } ''
          export RUFF_CACHE_DIR="$(mktemp -d)"

          echo -e "\x1b[32m## run mypy\x1b[0m"
          mypy ${src}
          echo -e "\x1b[32m## run ruff\x1b[0m"
          ruff check ${src}
          echo -e "\x1b[32m## run ruff format\x1b[0m"
          ruff format --check ${src}

          touch $out
        '';
      };
    };

  meta = {
    description = "Rebuild your NixOS configuration and switch to it, on local hosts and remote";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-rebuild-ng";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thiagokokada ];
    mainProgram = executable;
  };
}
