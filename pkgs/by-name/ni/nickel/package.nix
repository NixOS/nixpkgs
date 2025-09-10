{
  lib,
  boost,
  rustPlatform,
  fetchFromGitHub,
  python3,
  gitMinimal,
  versionCheckHook,
  pkg-config,
  nixVersions,
  nix-update-script,
  enableNixImport ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nickel";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = "nickel";
    tag = finalAttrs.version;
    hash = "sha256-YYDYVZ0rMO3bEHcBBSOup0gieg96hqT6XUqWM9h4yeI=";
  };

  cargoHash = "sha256-hsyAa8rLd/usoArZKfO5+92nLh4/sq9X0fpJncN4Ik4=";

  cargoBuildFlags = [
    "-p nickel-lang-cli"
    "-p nickel-lang-lsp"
  ];

  nativeBuildInputs = [
    python3
    gitMinimal
  ]
  ++ lib.optionals enableNixImport [
    pkg-config
  ];

  buildInputs = lib.optionals enableNixImport [
    nixVersions.nix_2_28
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

  cargoTestFlags = [
    # Skip the py-nickel tests because linking them fails on aarch64, and we
    # aren't packaging py-nickel anyway
    "--workspace"
    "--exclude=py-nickel"
  ];

  postInstall = ''
    mkdir -p $nls/bin
    mv $out/bin/nls $nls/bin/nls
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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
      yannham
    ];
    mainProgram = "nickel";
  };
})
