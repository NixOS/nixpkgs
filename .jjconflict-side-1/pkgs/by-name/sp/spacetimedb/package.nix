{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  git,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ay9nJ4b+lRBbZU/LmpG8agLcjp3jyDFyJdESeNoGsLQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-O74clwtMQ1roSy9Jg0l4vzBKuG3DXHDx4yRH/pbT8E0=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  # Replace hardcoded git binary
  postPatch = ''
    substituteInPlace crates/cli/build.rs --replace-fail 'Command::new("git")' 'Command::new("${lib.getExe git}")'
  '';

  cargoBuildFlags = [ "-p spacetimedb-standalone -p spacetimedb-cli" ];

  checkFlags = [
    # requires wasm32-unknown-unknown target
    "--skip=codegen"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/spacetime";
  versionCheckProgramArg = "--version";

  postInstall = ''
    mv $out/bin/spacetimedb-cli $out/bin/spacetime
  '';

  meta = {
    description = "Full-featured relational database system that lets you run your application logic inside the database";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
