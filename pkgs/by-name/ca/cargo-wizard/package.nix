{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-wizard";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-wizard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WLGE2ZuytjSridZwfUTtNQF5woeBbx5ZoHfB9eyvedI=";
  };

  cargoHash = "sha256-vRakgwZRyYkk3xFfZzl197tgRmx+/g2b8eaDunwrCzM=";

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTarget}/$cargoBuildType
  '';

  meta = {
    description = "Cargo subcommand for configuring Cargo profile for best performance";
    homepage = "https://github.com/kobzol/cargo-wizard";
    changelog = "https://github.com/kobzol/cargo-wizard/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "cargo-wizard";
  };
})
