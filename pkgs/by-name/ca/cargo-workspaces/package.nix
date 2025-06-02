{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libssh2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.3.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-JqLKFVM/EnVAPF7erINpHdaaDG+g2nbB0iE/hB1gml8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EfTcbgvOQ2KgUpu4+QBUVTaz/ToH9FuMHlXMpJN1BK4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libssh2
    openssl
    zlib
  ];

  env = {
    LIBSSH2_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Tool for managing cargo workspaces and their crates, inspired by lerna";
    longDescription = ''
      A tool that optimizes the workflow around cargo workspaces with
      git and cargo by providing utilities to version, publish, execute
      commands and more.
    '';
    homepage = "https://github.com/pksunkara/cargo-workspaces";
    changelog = "https://github.com/pksunkara/cargo-workspaces/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      macalinao
      matthiasbeyer
    ];
    mainProgram = "cargo-workspaces";
  };
}
