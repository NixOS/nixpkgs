{
  lib,
  installShellFiles,
  mkShell,
  nix,
  python3,
  python3Packages,
  runCommand,
  scdoc,
  withNgSuffix ? true,
  withShellFiles ? true,
}:
let
  executable = if withNgSuffix then "nixos-rebuild-ng" else "nixos-rebuild";
in
python3Packages.buildPythonApplication rec {
  pname = "nixos-rebuild-ng";
  version = "0.0.0";
  src = ./src;
  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    tabulate
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
    nix
  ];

  postPatch = ''
    substituteInPlace nixos_rebuild/__init__.py \
      --subst-var-by executable ${executable} \
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

  passthru =
    let
      python-with-pkgs = python3.withPackages (
        ps: with ps; [
          mypy
          pytest
          ruff
          types-tabulate
          # dependencies
          tabulate
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

      # NOTE: this is a passthru test rather than a build-time test because we
      # want to keep the build closures small
      tests.ci = runCommand "${pname}-ci" { nativeBuildInputs = [ python-with-pkgs ]; } ''
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

  meta = {
    description = "Rebuild your NixOS configuration and switch to it, on local hosts and remote";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-rebuild-ng";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.thiagokokada ];
    mainProgram = executable;
  };
}
