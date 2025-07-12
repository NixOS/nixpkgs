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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Fqv3g9e/9i5JMYHwbymm0n2mBEI0207TAyu/nF39Xk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-N7A7GAdk9j84qtKHTMtloU469FRwiYtqUdSytFVidlA=";

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
