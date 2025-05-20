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
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eBbRdkJafkMXOEsnh1yoht8WJAwZToPobWnhjTWhnA4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gs1A/gtjA941TWZw+wxMR+9TCayRa1k49/G8XnzW2ek=";

  nativeBuildInputs = [
    pkg-config
    perl
    git
  ];

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
