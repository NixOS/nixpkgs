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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L3D7DfMQNuoZ/twAsrK20royIGp6PXCAFZKnb0PgSu0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eOZRp3LRbQzHfT+evKY55ifevX+ki9oT5B7vZs3ym+c=";

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
