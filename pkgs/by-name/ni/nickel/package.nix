{
  lib,
  boost,
  rustPlatform,
  fetchFromGitHub,
  python3,
  versionCheckHook,
  pkg-config,
  nix,
  nix-update-script,
  enableNixImport ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nickel";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nickel";
    tag = finalAttrs.version;
    hash = "sha256-CnEGC4SnLRfAPl3WTv83xertH2ulG5onseZpq3vxfwc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CyO+W4332fJmeF2CL+9CCdPuion8MrxzkPotLA7my3U=";

  cargoBuildFlags = [
    "-p nickel-lang-cli"
    "-p nickel-lang-lsp"
  ];

  nativeBuildInputs =
    [
      python3
    ]
    ++ lib.optionals enableNixImport [
      pkg-config
    ];

  buildInputs = lib.optionals enableNixImport [
    nix
    boost
  ];

  buildFeatures = lib.optionals enableNixImport [ "nix-experimental" ];

  outputs = [
    "out"
    "nls"
  ];

  # This fixes the way comrak is defined as a dependency, without it the build fails:
  #
  # cargo metadata failure: error: Package `nickel-lang-core v0.10.0
  # (/build/source/core)` does not have feature `comrak`. It has an optional
  # dependency with that name, but that dependency uses the "dep:" syntax in
  # the features table, so it does not have an implicit feature with that name.
  preBuild = ''
    substituteInPlace core/Cargo.toml \
      --replace-fail "dep:comrak" "comrak"
  '';

  checkFlags = [
    # https://github.com/tweag/nickel/blob/1.10.0/git/tests/main.rs#L60
    # fails because src is not a git repo
    # `cmd.current_dir(repo.path()).output()` errors with `NotFound`
    "--skip=fetch_targets"
  ];

  postInstall = ''
    mkdir -p $nls/bin
    mv $out/bin/nls $nls/bin/nls
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://nickel-lang.org/";
    description = "Better configuration for less";
    longDescription = ''
      Nickel is the cheap configuration language.

      Its purpose is to automate the generation of static configuration files -
      think JSON, YAML, XML, or your favorite data representation language -
      that are then fed to another system. It is designed to have a simple,
      well-understood core: it is in essence JSON with functions.
    '';
    changelog = "https://github.com/tweag/nickel/blob/${finalAttrs.version}/RELEASES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felschr
      matthiasbeyer
    ];
    mainProgram = "nickel";
    badPlatforms = [
      # collect2: error: ld returned 1 exit status
      # undefined reference to `PyExc_TypeError'
      "aarch64-linux"
    ];
  };
})
