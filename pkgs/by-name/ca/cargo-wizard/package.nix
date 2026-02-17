{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-wizard";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kobzol";
    repo = "cargo-wizard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oFPSgjXZ+Kq59tV/7s6WPF6FHXENoZv8D245yyT0E9E=";
  };

  cargoHash = "sha256-ClulQP+1/RLvOWWB3uKTCn2Sx3+TO25qRs456DWHKu0=";

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
